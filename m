Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbaHFVAE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:00:04 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58194 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbaHFVAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:00:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Griffin <peter.griffin@linaro.org>
Subject: Re: [PATCH v3 1/6] usb: host: usb-st-common: Add common code required by ohci-st and ehci-st
Date: Wed, 6 Aug 2014 22:59:10 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org
References: <1407344589-24863-1-git-send-email-peter.griffin@linaro.org> <1407344589-24863-2-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1407344589-24863-2-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201408062259.10697.arnd@arndb.de>
X-Provags-ID: V02:K0:T8JXJbmfnnOqGVSnTlH3KI/DZO4uKKWtsgAf5SD8Ns2
 EScogEx4Axs3r3F5o9r7BIFJVp3yvsY+HcmWMw2t8Q+VY6aPW3
 KQxjvUrVXJVMmVxB46cWUhUjiocKvWXpy6mcU2LWKTQqgUIkpP
 nfkYv4PMAqWIKsDdtHBAo/pWAnVAAoWbGFc2XyOtt6FU2fgwtJ
 6k8iB/tSnfmiZwpPLj0s67WmviIoQ4DfgtbQvmxfCqXHhCVz/g
 Ihn1/fH1ZdZ5nkxcdg2Ma6MK20LeyyScQCBGOpmCy5/33arDCX
 9TP8jvUeA8fGwM3zpo0Vy+GEZe8zcCk7t/alhTGfddPlBq6UFA
 02aizzzEAfrWTE45N7dlHfcibMvH7wBqZaKu8CyZG
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2014, Peter Griffin wrote:
> +int st_usb_platform_power_on(struct st_platform_priv *priv)
> +{
> +	int clk, ret;
> +
> +	if (priv->pwr) {
> +		ret = reset_control_deassert(priv->pwr);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	if (priv->rst) {
> +		ret = 
> (priv->rst);
> +		if (ret)
> +			goto err_assert_power;
> +	}

I wouldn't make these optional, just call the functions
unconditionally and fail the probe function if they are
not available.

I'm not sure if it's worth keeping these functions in a
common file. You are adding complexity this way and I don't
think you are even saving a significant number of code lines
compared to just having two copies of them.

> +EXPORT_SYMBOL(st_usb_platform_power_on);

If you want to keep them, it would be best to make

	Arnd
