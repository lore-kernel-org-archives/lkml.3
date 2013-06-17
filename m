Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab3FQXVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:21:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3FQXVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:21:21 -0400
Date: Mon, 17 Jun 2013 16:21:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org,
        Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/8] FMC: add needed headers
Message-ID: <20130617232120.GF12984@kroah.com>
References: <cover.1371018406.git.rubini@gnudd.com>
 <1d3aedf8636f4bed4ffda25e13acd853bf8e08fb.1371018406.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d3aedf8636f4bed4ffda25e13acd853bf8e08fb.1371018406.git.rubini@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 09:13:36AM +0200, Alessandro Rubini wrote:
> +/*
> + * The device reports all information needed to access hw.
> + *
> + * If we have eeprom_len and not contents, the core reads it.
> + * Then, parsing of identifiers is done by the core which fills fmc_fru_id..
> + * Similarly a device that must be matched based on SDB cores must
> + * fill the entry point and the core will scan the bus (FIXME: sdb match)
> + */
> +struct fmc_device {
> +	unsigned long version;
> +	unsigned long flags;
> +	struct module *owner;		/* char device must pin it */
> +	struct fmc_fru_id id;		/* for EEPROM-based match */
> +	struct fmc_operations *op;	/* carrier-provided */
> +	int irq;			/* according to host bus. 0 == none */
> +	int eeprom_len;			/* Usually 8kB, may be less */
> +	int eeprom_addr;		/* 0x50, 0x52 etc */
> +	uint8_t *eeprom;		/* Full contents or leading part */
> +	char *carrier_name;		/* "SPEC" or similar, for special use */
> +	void *carrier_data;		/* "struct spec *" or equivalent */
> +	__iomem void *fpga_base;	/* May be NULL (Etherbone) */
> +	__iomem void *slot_base;	/* Set by the driver */
> +	struct fmc_device **devarray;	/* Allocated by the bus */
> +	int slot_id;			/* Index in the slot array */
> +	int nr_slots;			/* Number of slots in this carrier */
> +	unsigned long memlen;		/* Used for the char device */
> +	struct device dev;		/* For Linux use */
> +	struct device *hwdev;		/* The underlying hardware device */
> +	unsigned long sdbfs_entry;
> +	struct sdb_array *sdb;
> +	uint32_t device_id;		/* Filled by the device */
> +	char *mezzanine_name;		/* Defaults to ``fmc'' */
> +	void *mezzanine_data;
> +};
> +#define to_fmc_device(x) container_of((x), struct fmc_device, dev)
> +
> +#define FMC_DEVICE_HAS_GOLDEN		1
> +#define FMC_DEVICE_HAS_CUSTOM		2
> +#define FMC_DEVICE_NO_MEZZANINE		4
> +#define FMC_DEVICE_MATCH_SDB		8 /* fmc-core must scan sdb in fpga */

Any way you can use MODULE_DEVICE_TABLE() for these devices to get
proper module auto-loading for your drivers?

thanks,

greg k-h
