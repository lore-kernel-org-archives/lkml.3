Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaE1XuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:50:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43775 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbaE1XuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:50:01 -0400
Message-ID: <5386758C.4040702@zytor.com>
Date: Wed, 28 May 2014 16:47:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>, linux-kernel@vger.kernel.org,
        lxc-devel@lists.linuxcontainers.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Michael H. Warfield" <mhw@wittsend.com>, Marian Marinov <mm@1h.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael J Coss <michael.coss@alcatel-lucent.com>
Subject: Re: [RFC PATCH 0/2] Loop device psuedo filesystem
References: <1401227936-15698-1-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1401227936-15698-1-git-send-email-seth.forshee@canonical.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 02:58 PM, Seth Forshee wrote:
> 
> The patches implement a psuedo filesystem for loop devices, which will
> allow use of loop devices in containters using standard utilities. Under
> normal use a loopfs mount will initially contain a single device node
> for loop-control which can be used to request and release loop devices.
> Any devices allocated via this node will automatically appear in that
> loopfs mount (and in devtmpfs) but not in any other loopfs mounts.
> CAP_SYS_ADMIN in the userns of the process which performed the mount is
> allowed to perform privileged loop ioctls on these devices.
> 
> Alternately loopfs can be mounted with the hostmount option, intended
> for mounting /dev/loop in the host. This is the default mount for any
> devices not created via loop-control in a loopfs mount (e.g. devices
> created during driver init, devices created via /dev/loop-control, etc).
> This is only available to system-wide CAP_SYS_ADMIN.
> 

May I instead strongly advocate a slightly different solution: leave
legacy loop devices where they are, with the current semantics, and let
them be.  Make the loopfs loop devices completely independent.  Consider
this equivalent of Unix98 ptys versus legacy BSD ptys.

Then, hopefully, use of the legacy ones will disappear over time.
Enabling the new ones in losetup and friends is simple enough; this is
not like ptys where the old scheme was hard-coded into a hundred
different applications.

	-hpa

