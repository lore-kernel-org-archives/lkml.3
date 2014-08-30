Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaH3Mwc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 08:52:32 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:62295 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751802AbaH3Mw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 08:52:29 -0400
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Aug 2014 08:52:28 EDT
Message-ID: <1409402838.21896.99.camel@x220>
Subject: Re: [PATCH 1/5] kexec: Fix make headers_check
From: Paul Bolle <pebolle@tiscali.nl>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Geoff Levand <geoff@infradead.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, kexec@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        maximilian attems <max@stro.at>
Date: Sat, 30 Aug 2014 14:47:18 +0200
In-Reply-To: <20140825172234.GD14379@redhat.com>
References: <cover.1408731991.git.geoff@infradead.org>
	 <115373b6ac68ee7a305975896e1c4971e8e51d4c.1408731991.git.geoff@infradead.org>
	 <20140825172234.GD14379@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Aug 2014 12:47:18.0460 (UTC) FILETIME=[888FFFC0:01CFC450]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added Peter Anvin.]

On Mon, 2014-08-25 at 13:22 -0400, Vivek Goyal wrote:
> On Fri, Aug 22, 2014 at 06:39:47PM +0000, Geoff Levand wrote:
> > Remove the unneded declaration for a kexec_load() routine.
> > 
> > Fixes errors like these when running 'make headers_check':
> > 
> > include/uapi/linux/kexec.h: userspace cannot reference function or variable defined in the kernel
> > 
> > Signed-off-by: Geoff Levand <geoff@infradead.org>
> 
> I think Paul Bolle tried to remove this in the past and maximilian
> had objections.
> 
> http://lists.infradead.org/pipermail/kexec/2014-January/010902.html

I've wanted to resend my patch, perhaps with a new commit explanation,
for quite some time now. I never got around doing that.

> I can't see that how exporting kernel prototype helps here.

It doesn't, for the reasons I've set out in
http://lists.infradead.org/pipermail/kexec/2014-January/010900.html . In
short: why bother using this prototype if one still needs to define the
matching function oneself?

> kexec-tools
> seems to be using syscall(__NR_kexec_load) directly for non-xen case. So
> I would be fine with removing this definition. Just trying to make sure
> that it does not break any other library or users of this declaration.

Obviously, this can only break compiling those libraries, or other
users. It can't break already compiled binaries. Besides I don't think
those libraries, etc actually exist. Maximilian mentioned klibc in
January, but I wasn't able to find a version of klibc that cared about
this prototype. No one pointed me at a version that does (or any other
library, etc., for that matter).

(If we do decide to keep this prototype, we should special case this
prototype in headers_check.pl just to silence the build.)

The above can be summarized like this:
    Acked-by: Paul Bolle <pebolle@tiscali.nl>


Paul Bolle

