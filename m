Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3FIP5D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 11:57:03 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:56087 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401Ab3FIP5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 11:57:01 -0400
Message-ID: <51B4A693.4080503@metafoo.de>
Date: Sun, 09 Jun 2013 18:00:19 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
CC: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] regmap: Add regmap_field APIs
References: <1369753080-1929-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1369753080-1929-1-git-send-email-srinivas.kandagatla@st.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
> +int regmap_field_write(struct regmap_field *field, unsigned int val)
> +{
> +	int field_bits;
> +	unsigned int reg_mask;
> +	field_bits = field->msb - field->lsb + 1;
> +	reg_mask = ((BIT(field_bits) - 1) << field->lsb);
> +	return regmap_update_bits(field->regmap, field->reg,
> +				reg_mask, val << field->lsb);

Considering that you'd do the same calculations over and over again it would
probably make more sense store the mask rather than the msb in the struct

> +}
> +EXPORT_SYMBOL_GPL(regmap_field_write);
