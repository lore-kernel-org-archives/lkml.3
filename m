Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563AbaFQNZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 09:25:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332AbaFQNZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 09:25:13 -0400
Date: Tue, 17 Jun 2014 09:24:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC PATCH 00/13][V3] kexec: A new system call to allow in
 kernel loading
Message-ID: <20140617132426.GB28340@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <20140616211328.GK8170@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616211328.GK8170@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 11:13:28PM +0200, Borislav Petkov wrote:
> On Tue, Jun 03, 2014 at 09:06:49AM -0400, Vivek Goyal wrote:
> > This patch series does not do kernel signature verification yet. I
> > plan to post another patch series for that. Now bzImage is already
> > signed with PKCS7 signature I plan to parse and verify those
> > signatures.
> 
> Btw, do you have a brief outline on how you are going to do the
> extension to signature verification? Nothing formal, just enough of an
> outline that I can see where in the flow it will be plugged in.
> 
> I was wondering how the whole signature signing and verification will
> be done, i.e., where do I get the signature, how and who will verify it
> (I'm guessing the purgatory code), etc, etc.

Hi Boris,

I am still working on signing patches. I have uploaded them here for you
to have a look.

http://people.redhat.com/vgoyal/kdump-secureboot/in-kernel-kexec/bzimage-sig-verification/

Last patch should give you a good idea how signature verification hooks
into kexec.

Signature verification patches are based on David Howell's work.

There is no purgatory involved here. Once we have copied kernel image
into kernel space, first thing we do is call into arch image loader
and ask it to verify signature of image. And bzImage loader in turn
calls into helper functions which can parse a PE signed file and
verify image signature.

I have yet to cleanup the code, implement a config option which enforces
signature verification.

Automatic enforncement of signature verification if secureboot is
enabled will happen once matthew's secureboot patches are merged 
into mainline.

Thanks
Vivek
