Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752779AbbAUNCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 08:02:19 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:45211 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbbAUNCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 08:02:11 -0500
Date: Wed, 21 Jan 2015 13:02:04 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, kernel@stlinux.com,
        Angus Clark <angus.clark@st.com>,
        Carmelo Amoroso <carmelo.amoroso@st.com>
Subject: Re: [PATCH v3 08/13] mtd: st_spi_fsm: Update the JEDEC probe to
 handle extended READIDs
Message-ID: <20150121130204.GC22024@x1>
References: <1418644760-18773-1-git-send-email-lee.jones@linaro.org>
 <1418644760-18773-9-git-send-email-lee.jones@linaro.org>
 <20150113050715.GQ9759@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150113050715.GQ9759@ld-irv-0074>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Jan 2015, Brian Norris wrote:

> On Mon, Dec 15, 2014 at 11:59:15AM +0000, Lee Jones wrote:
> > The previous code was based on 3-byte JEDEC IDs, with a possible 2-byte
> > extension.  However, devices are now emerging that return 6 or more bytes of
> > READID data and the additional bytes are required to differentiate between
> > variants or generations of similar devices.
> > 
> > This patch refactors the device table and JEDEC probe code to handle arbitrary
> > length READIDs, with the standard JEDEC definition now becoming a special case.
> > Functionally, there should be no change in behaviour.  A subsequent patch will
> > update the table with extended READIDs where applicable.
> 
> BTW, how's that promise going, where you work on adapting this driver to
> the spi-nor framework? We've already done some of this same work there.

I have pushed this point within ST and someone has agreed to do the
work.  Last I heard it relied on these patches, but I'll ask again.

> > +#define RDID(...) __VA_ARGS__  /* Dummy macro to protect array argument. */
> 
> What? What needs "protected"?

You're asking me questions I can't answer I'm afraid and Angus has now
left the building.  I guess he thinks __VA_ARGS__ will prevent some
kind of overflow?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
