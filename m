Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaKSOOF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:14:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:30963 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbaKSOOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:14:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,417,1413270000"; 
   d="scan'208";a="634523840"
Date: Wed, 19 Nov 2014 16:12:40 +0200
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] spi: add support for DLN-2 USB-SPI adapter
Message-ID: <20141119141239.GE2583@lpalcu-linux>
References: <1416394031-2663-1-git-send-email-laurentiu.palcu@intel.com>
 <1416402467-26999-1-git-send-email-laurentiu.palcu@intel.com>
 <20141119135121.GF7857@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119135121.GF7857@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 02:51:21PM +0100, Johan Hovold wrote:
> On Wed, Nov 19, 2014 at 03:07:47PM +0200, Laurentiu Palcu wrote:
> 
> > +/*
> > + * Perform one read operation.
> > + */
> > +static int dln2_spi_read_one(struct dln2_spi *dln2, u8 *data,
> > +			     u16 data_len, u8 attr)
> > +{
> > +	int ret;
> > +	struct {
> > +		u8 port;
> > +		__le16 size;
> > +		u8 attr;
> > +	} __packed tx;
> > +	struct {
> > +		__le16 size;
> > +		u8 buf[DLN2_SPI_MAX_XFER_SIZE];
> > +	} __packed *rx = dln2->buf;
> 
> You said you verified that the dln2 protocol headers did not mess up the
> alignment, yet they do. Here you have a two byte header.
I did, only that I mistakenly counted the entire header, including
dln2_response struct size, which is 10 bytes... :/

thanks,
laurentiu

