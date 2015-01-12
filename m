Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbbALMId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:08:33 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34148 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751951AbbALMIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:08:31 -0500
Date: Mon, 12 Jan 2015 12:08:14 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 02/11] i2c: add quirk checks to core
Message-ID: <20150112120814.GE12302@n2100.arm.linux.org.uk>
References: <1420824103-24169-1-git-send-email-wsa@the-dreams.de>
 <1420824103-24169-3-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420824103-24169-3-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 06:21:32PM +0100, Wolfram Sang wrote:
> +static int i2c_quirk_error(struct i2c_adapter *adap, struct i2c_msg *msg, char *err_msg)
> +{
> +	dev_err(&adap->dev, "quirk: %s (addr 0x%04x, size %u)\n", err_msg, msg->addr, msg->len);
> +	return -EOPNOTSUPP;
> +}

So, what happens if I open an I2C adapter, find a message which causes
i2c_quirk_error() to be called, and then spin repeatedly calling that...
Shouldn't there be some rate limiting to this?

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
