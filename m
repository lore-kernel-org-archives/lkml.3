Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaJPIpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 04:45:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaJPIpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 04:45:17 -0400
Date: Thu, 16 Oct 2014 10:44:12 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Andreas Werner <andreas.werner@men.de>
Cc: linux-kernel@vger.kernel.org, wsa@the-dreams.de, linux-i2c@vger.kernel.org,
        johannes.thumshirn@men.de
Subject: Re: [PATCH 1/2] drivers/misc/eeprom/men_eeprod: Introduce MEN Board
 Information EEPROM driver
Message-ID: <20141016084412.GB22265@kroah.com>
References: <cover.1413416105.git.andreas.werner@men.de>
 <d169930cfe45d4c05c79f7dd00471d732441529d.1413416105.git.andreas.werner@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d169930cfe45d4c05c79f7dd00471d732441529d.1413416105.git.andreas.werner@men.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 10:15:08AM +0200, Andreas Werner wrote:
> +struct eeprom_data {
> +	uint8_t eeprod_id;

Please use the "real" kernel types, "u8" here, and "u32" in other places
you use uint32_t (those are userspace types, not kernel types, sorry.)

> +static DEVICE_ATTR(eeprod_id, S_IRUGO, show_eeprod_id, NULL);
> +static DEVICE_ATTR(revision, S_IRUGO, show_revision, NULL);
> +static DEVICE_ATTR(serial, S_IRUGO, show_serialnr, NULL);
> +static DEVICE_ATTR(hw_name, S_IRUGO, show_hw_name, NULL);
> +static DEVICE_ATTR(prod_date, S_IRUGO, show_prod_date, NULL);
> +static DEVICE_ATTR(rep_date, S_IRUGO, show_rep_date, NULL);

DEVICE_ATTR_RO() please.
