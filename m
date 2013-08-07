Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab3HGUY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:24:57 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60200 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932343Ab3HGUYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:24:55 -0400
Date: Wed, 7 Aug 2013 21:24:51 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Andrew Fish <afish@apple.com>
Cc: edk2-devel@lists.sourceforge.net, Laszlo Ersek <lersek@redhat.com>,
        linux-efi@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [edk2] Corrupted EFI region
Message-ID: <20130807202451.GH2515@console-pimps.org>
References: <20130805161247.GF31845@pd.tnic>
 <51FFD5B0.9080000@redhat.com>
 <20130805164731.GG31845@pd.tnic>
 <52001896.1030509@redhat.com>
 <20130805220808.GC14067@pd.tnic>
 <20130806141036.GD14891@pd.tnic>
 <520116D1.2010000@redhat.com>
 <20130807151935.GJ17920@pd.tnic>
 <CCFD3CBD-62B0-4046-B96D-18CB1A815F72@apple.com>
 <20130807201908.GG2515@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807201908.GG2515@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Adding Matthew for reals this time ]

On Wed, 07 Aug, at 09:19:08PM, Matt Fleming wrote:
> [ Readding Matthew Garrett to the Cc list, seeing as we both got removed
>   for some unknown reason ]
> 
> On Wed, 07 Aug, at 10:23:56AM, Andrew Fish wrote:
> 
> > OK so I think I need some Cliff Notes here to help me understand what
> > is going on...
> > 
> > type 4 is EfiBootServicesData and attr 0x0f is cache attributes with
> > no request for a runtime mapping. This is not runtime memory so to the
> > OS loader it is just memory EFI has used that will get freed back to
> > the OS after ExitBootServices(), along with EfiBootServicesCode,
> > EfiLoaderCode, and EfiLoaderData. The EfiLoaderCode and EfiLoaderData
> > also get freed back to the OS and they just exist for the convenience
> > of the OS loader. 
> > 
> > So I can't figure out why this maters? Given:
> 
> We've seen a bunch of systems that make calls into EfiBootServicesCode
> after ExitBootServices(). There were some Apple machines in that list,
> though I don't have the details but Matthew should.
>  
> So we map these regions unconditionally and in their original state,
> otherwise the firmware will generate fatal page faults when trying to
> access those memory regions.

-- 
Matt Fleming, Intel Open Source Technology Center
