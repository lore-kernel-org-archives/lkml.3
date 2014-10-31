Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161645AbaJaB6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 21:58:50 -0400
Received: from relay3.sgi.com ([192.48.152.1]:59951 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161473AbaJaB6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 21:58:48 -0400
Date: Fri, 31 Oct 2014 01:58:43 +0000
From: Hedi Berriche <hedi@sgi.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>, kexec@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>, linux-doc@vger.kernel.org,
        jbaron@akamai.com, Fabian Frederick <fabf@skynet.be>,
        isimatu.yasuaki@jp.fujitsu.com, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
        vgoyal@redhat.com
Subject: Re: [PATCH] kernel, add panic_on_warn
Message-ID: <20141031015843.GW9743@dangermouse.emea.sgi.com>
Mail-Followup-To: Prarit Bhargava <prarit@redhat.com>,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>, kexec@lists.infradead.org,
	Rusty Russell <rusty@rustcorp.com.au>, linux-doc@vger.kernel.org,
	jbaron@akamai.com, Fabian Frederick <fabf@skynet.be>,
	isimatu.yasuaki@jp.fujitsu.com, "H. Peter Anvin" <hpa@zytor.com>,
	Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-api@vger.kernel.org, vgoyal@redhat.com
References: <1414688627-5298-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1414688627-5298-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 17:06 Prarit Bhargava wrote:
| There have been several times where I have had to rebuild a kernel to
| cause a panic when hitting a WARN() in the code in order to get a crash
| dump from a system.  Sometimes this is easy to do, other times (such as
| in the case of a remote admin) it is not trivial to send new images to the
| user.
| 
| A much easier method would be a switch to change the WARN() over to a
| panic.  This makes debugging easier in that I can now test the actual
| image the WARN() was seen on and I do not have to engage in remote
| debugging.

Do we want to leave it to usersspace[1] to ensure panic_on_warn is out
of the way in when the kdump kernel boots? or would a self-contained
approach be more preferable i.e. test whether we're a kdump kernel
before bothering with panic_on_warn?

Cheers,
Hedi.

[1] kexec-tools in the case of the boot param by filtering it out of the
    kdump kernel cmdline. In the case of sysctl.conf, it would depend on
    whether there are distros out there that  include it in the kdump
    initrd.

-- 
Hedi Berriche
Linux Kernel Engineer
http://www.sgi.com
