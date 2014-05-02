Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaEBA5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 20:57:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58508 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaEBA5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 20:57:00 -0400
Date: Fri, 2 May 2014 01:56:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: Connecting to sockets on MNT_READONLY mounts?
Message-ID: <20140502005659.GF18016@ZenIV.linux.org.uk>
References: <CALCETrUXbS4BMWMd0XXgFqyvmpu+WML840_mzbPiov8WmaA=Xw@mail.gmail.com>
 <20140501223432.GD18016@ZenIV.linux.org.uk>
 <CALCETrXaXsVxaT3TH-CC8DKyDU7k=i9Y5PqBqaSDnH+2rr5E2A@mail.gmail.com>
 <20140501235135.GE18016@ZenIV.linux.org.uk>
 <CALCETrXhVKq33-KWLMVxPtCZgHddKsxCOQX9F-LGerXsCrLH5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXhVKq33-KWLMVxPtCZgHddKsxCOQX9F-LGerXsCrLH5Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 04:57:13PM -0700, Andy Lutomirski wrote:

> Suppose I bind-mount /usr into a private namespace with
> nosuid,nodev,ro.  How can you use it to attack anything?  The only
> thing I've thought of is to open fifos and connect to sockets.  I'm
> assuming that there's a pid namespace blocking ptrace and such and a
> network namespace blocking abstract sockets.

How many FIFOs and sockets are there in your /usr?  Here all I see
outside of /dev, /run and /tmp (across seven boxen; I can check more, but
I really doubt it'll catch anything) is the grand total of 4:
/lib/cryptsetup/passfifo
/var/lib/oprofile/opd_pipe
/var/lib/nfs/rpc_pipefs/nfs/clnt0/idmap
/var/lib/nfs/rpc_pipefs/gssd/clntXX/gssd

None of those in /usr and I don't believe that you seriously propose to
bind e.g. /lib/cryptsetup into your sandbox.  And while we are at it,
exposing host /usr is *not* a good idea - if nothing else, it gives
quite a bit of information about the versions of software installed on
the host.  Ability to watch atime of /usr/bin/* also might be interesting,
etc.

Do you, by any chance, plan to expose the host /tmp or /run?  Or
rpc_pipefs, for that matter...
