Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3KVBZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:25:31 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:1610 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3KVBZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:25:29 -0500
Date: Thu, 21 Nov 2013 18:25:24 -0700
From: jerry.hoemann@hp.com
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, matt.fleming@intel.com,
        yinghai@kernel.org, akpm@linux-foundation.org, bp@suse.de,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, penberg@kernel.org,
        mingo.kernel.org@gmail.com, vgoyal@redhat.com
Subject: Re: [RFC v2 0/2] Early use of boot service memory
Message-ID: <20131122012524.GA5627@anatevka.fc.hp.com>
Reply-To: jerry.hoemann@hp.com
References: <1385067686-73500-1-git-send-email-jerry.hoemann@hp.com>
 <20131121230744.GA31592@srcf.ucam.org>
 <528E94D1.2050809@zytor.com>
 <20131121233705.GA32121@srcf.ucam.org>
 <528EAF99.1010503@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528EAF99.1010503@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 05:12:57PM -0800, H. Peter Anvin wrote:
> On 11/21/2013 03:37 PM, Matthew Garrett wrote:
> > On Thu, Nov 21, 2013 at 03:18:41PM -0800, H. Peter Anvin wrote:
> >> On 11/21/2013 03:07 PM, Matthew Garrett wrote:
> >>> This is a problem we have to solve, but I don't think this is the right 
> >>> way to solve it. Why do we not just reattempt to perform the allocation 
> >>> immediately after we've freed the boot services regions?
> >>>
> >>
> >> Wouldn't the memory map already have gotten scrambled all to hell by then?
> > 
> > If we couldn't map a 64MB region in low memory earlier then it's likely 
> > to have been because there was a 64MB or greater boot services region.
> > 
> 
> I thought the problem was that they wanted to map a fairly large chunk
> for faster kdump and fragmentation was being a problem.
> 
> 	-hpa


larger crash dump reservation is not so much performance as functionality.

Large systems w/ lots of IO require large crash kernel allocations for
the kernel to boot.  Then you have to worry about the OOM killer..... 

makedumpfile going to cyclic buffer has helped out greatly, but on
our new systems we're still looking at 512 MB crash kernels.



-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

