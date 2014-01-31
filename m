Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbaAaUPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 15:15:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:64722 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbaAaUPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 15:15:44 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: srinivas kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 1/4] ARM: STi: add stid127 soc support
Date: Fri, 31 Jan 2014 21:15:33 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, kernel@stlinux.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>, linux-kernel@vger.kernel.org,
        Stuart Menefy <stuart.menefy@st.com>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, maxime.coquelin@st.com,
        alexandre.torgue@st.com
References: <1391093744-19905-1-git-send-email-patrice.chotard@st.com> <201401301939.08302.arnd@arndb.de> <52EB96BB.6070800@st.com>
In-Reply-To: <52EB96BB.6070800@st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401312115.33731.arnd@arndb.de>
X-Provags-ID: V02:K0:hjgdS8/F5kKIw1Lzcy5IWav8vgp8ga4NmpebA6RUu3t
 AzPGamwJsWmQsMWzT9uWQuT/6K7UgfUxa9/Odn/qtj1A+jGDgf
 /2Jbmn3+Jnxu8LUhM6zg9JXti2Z7PW8/h11+Q/+mDBxbDFsn5s
 H2nHZ3YVecXTyoayMX+LLS/tekbyz3WrY0tWadkDkW2exlJ9Jp
 Phvg3W5ca2wB6LM22xRZa0gIW/vy3iIorc3giQuh3Vsy47mIaP
 6atYkCrcr8WUp+NPZ13mCSXA0WPNAukUIQlqYlyGaOC76m3QDP
 3s3bQAAX6HmWbxyqCYGQgvzJ/fdFquOr+G3Av70hwyUOCZvlLL
 L6uGWY4hCbU6yjB4/HX0IARa7pePkvmKOP89W6EIW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 January 2014, srinivas kandagatla wrote:

> > Sorry if I missed the initial review, but can you explain
> > why this is needed to start with?
>
> On ST SoCs the default value for L2 AUX_CTRL register is 0x0, so we  set
> the way-size explicit here.

Unfortunately, we keep going back and forth on the L2 cache controller
setup between "it should work automatically" and "we don't want to
have configuration data in DT", where my personal opinion is that
the first one is more important here.

Now, there are a couple of properties that are defined in
Documentation/devicetree/bindings/arm/l2cc.txt to let some of the
things get set up automatically already. Can you check which bits
are missing there, if any? Are they better described as "configuration"
or "hardware" settings?

	Arnd
