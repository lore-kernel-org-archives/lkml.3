Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab3EHQPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:15:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36081 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab3EHQP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:15:28 -0400
Date: Wed, 8 May 2013 09:15:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will.deacon@arm.com>, jslaby@suse.cz,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, Nicolas Pitre <nico@linaro.org>,
        linux-doc@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>,
        linux-serial@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/8] serial:st-asc: Add ST ASC driver.
Message-ID: <20130508161527.GA28080@kroah.com>
References: <1368022187-1633-1-git-send-email-srinivas.kandagatla@st.com>
 <1368022248-2153-1-git-send-email-srinivas.kandagatla@st.com>
 <201305081634.43498.arnd@arndb.de>
 <20130508153459.GA17186@kroah.com>
 <20130508154057.GB3041@game.jcrosoft.org>
 <20130508155301.GB27273@kroah.com>
 <B5A00B86-5332-427E-A82A-5B71EC0979A8@jcrosoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B5A00B86-5332-427E-A82A-5B71EC0979A8@jcrosoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 09, 2013 at 12:03:05AM +0800, Jean-Christophe PLAGNIOL-VILLARD wrote:
> 
> On May 8, 2013, at 11:53 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Wed, May 08, 2013 at 05:40:57PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> >> On 08:34 Wed 08 May     , Greg KH wrote:
> >>> On Wed, May 08, 2013 at 04:34:43PM +0200, Arnd Bergmann wrote:
> >>>>> +#define ASC_MAJOR		204
> >>>>> +#define ASC_MINOR_START		40
> >>>> 
> >>>> I don't know what the current policy is on allocating major/minor numbers,
> >>>> but I'm sure you cannot just reuse one that is already used.
> >>> 
> >>> I agree, why are you trying to create a new tty device name?  Can't you
> >>> use the existing ttyS name and minor number as you will not have any
> >>> other type of serial device on this system?
> >> 
> >> Greg on ST STB for more than 10 years we use ttyASC I'll prefer ttySx
> > 
> > For 10+ years you have had an out-of-tree serial driver?
> yes ST have it out of tree for very long time even I puts them to come mainline

Crazy...

> >  What
> > major/minor numbers did you use for it?
> 
> http://git.stlinux.com/?p=havana/com.st.havana.kernel.git;a=blob;f=drivers/serial/stm-asc.h;h=79e003ffeb21df55a6af94774fc9c4b3d8de18e9;hb=HEAD
> 
>   52 #define ASC_MAJOR               204
>   53 #define ASC_MINOR_START         40
> 
> same as in this patch

Ok, but just because you have been using an out-of-tree name, and
non-reserved major/minor, doesn't mean we have to accept it.  As you are
probably using a tool like udev/devtmpfs on your systems, the
major/minor number shouldn't matter, only the name.

And I'd argue that we should change the name as well.

> >> on the DTB SoC you have one one IP present the st,asc
> > 
> > I don't understand, what do you mean by this?
> > 
> > confused,
> 
> just mention there is not hardware reason to not use the generic ttySx
> in place of ttyAS as we have only one IP that handle serial on this
> family of SoC
> 
> personally I'll switch to ttySx

Great, then you can use the same major/minor range as well, so there's
no more objection from me about this :)

thanks,

greg k-h
