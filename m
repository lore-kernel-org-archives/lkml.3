Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbaHKSQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 14:16:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbaHKSQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 14:16:23 -0400
Date: Mon, 11 Aug 2014 14:15:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Shaun Ruffell <sruffell@digium.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, ebiederm@xmission.com, mjg59@srcf.ucam.org,
        greg@kroah.com, bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com,
        bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 11/15] purgatory: Core purgatory functionality
Message-ID: <20140811181543.GD1863@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
 <1403814824-7587-12-git-send-email-vgoyal@redhat.com>
 <20140811174017.GD12610@digium.com>
 <53E9028E.2070709@zytor.com>
 <20140811180213.GC1863@redhat.com>
 <53E906B0.5040105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E906B0.5040105@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 11:08:48AM -0700, H. Peter Anvin wrote:
> On 08/11/2014 11:02 AM, Vivek Goyal wrote:
> > 
> > Hi hpa,
> > 
> > I took it because kexec-tools uses it and in one of the committs Eric
> > gave following reasoning.
> > 
> >     On x86_64 use -mcmodel=large so that the code is built without
> >     any 32bit assumptions.  -mcmodel=medium and -mcmodel=small
> >     result int code that has 32bit relocations against variables
> >     that can live anywhere in the address space
> > 
> > We do want to load purgatory anywhere in the address space. 
> > 
> > But if there are other ways to achieve the same thing, I will do that
> > change.
> > 
> > So when you say "small PIC", I need to use -mcmodel=small and -fPIC?
> > 
> 
> Actually -fPIE is probably better than -fPIC.
> 
> -mcmodel=large is incompatible with all other code out there, which
> means that even though it is supposed to work it will be poorly tested
> at best.  So even despite the gcc version issue, using the small PIC
> model would be better.

Ok, I will give it a try.

Thanks
Vivek
