Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaKCPTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:19:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbaKCPTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:19:15 -0500
Date: Mon, 3 Nov 2014 10:18:37 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>, kexec@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>, linux-doc@vger.kernel.org,
        jbaron@akamai.com, Fabian Frederick <fabf@skynet.be>,
        isimatu.yasuaki@jp.fujitsu.com, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org
Subject: Re: [PATCH] kernel, add panic_on_warn
Message-ID: <20141103151837.GA22503@redhat.com>
References: <1414688627-5298-1-git-send-email-prarit@redhat.com>
 <20141031015843.GW9743@dangermouse.emea.sgi.com>
 <545783FA.4050508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545783FA.4050508@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 08:32:42AM -0500, Prarit Bhargava wrote:
> 
> 
> On 10/30/2014 09:58 PM, Hedi Berriche wrote:
> > On Thu, Oct 30, 2014 at 17:06 Prarit Bhargava wrote:
> > | There have been several times where I have had to rebuild a kernel to
> > | cause a panic when hitting a WARN() in the code in order to get a crash
> > | dump from a system.  Sometimes this is easy to do, other times (such as
> > | in the case of a remote admin) it is not trivial to send new images to the
> > | user.
> > | 
> > | A much easier method would be a switch to change the WARN() over to a
> > | panic.  This makes debugging easier in that I can now test the actual
> > | image the WARN() was seen on and I do not have to engage in remote
> > | debugging.
> > 
> > Do we want to leave it to usersspace[1] to ensure panic_on_warn is out
> > of the way in when the kdump kernel boots? or would a self-contained
> > approach be more preferable i.e. test whether we're a kdump kernel
> > before bothering with panic_on_warn?
> 
> Hmm ... this is a good point.  Vivek, do you have a preference?  I'm willing to
> code it either way.  I should be able to put in a is_kdump_kernel() check
> without any problems but I'm not sure if that is the right thing to do here.
> 

I think it will make sense to modify user space scripts to get rid of
panic_on_warn for kdump kernel.

Thanks
Vivek
