Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab3C2TeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:34:24 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:43215 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab3C2TeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:34:22 -0400
Message-ID: <5155ECBB.9000008@free-electrons.com>
Date: Fri, 29 Mar 2013 20:34:19 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linux-fbdev@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] video: ssd1307fb: Add support for SSD1306 OLED controller
References: <1362588251-1824-1-git-send-email-maxime.ripard@free-electrons.com> <1362588251-1824-2-git-send-email-maxime.ripard@free-electrons.com> <20130329183842.GH20693@game.jcrosoft.org>
In-Reply-To: <20130329183842.GH20693@game.jcrosoft.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean Christophe,

Le 29/03/2013 19:38, Jean-Christophe PLAGNIOL-VILLARD a écrit :
> On 17:44 Wed 06 Mar     , Maxime Ripard wrote:

[snip]

>>  static int ssd1307fb_probe(struct i2c_client *client,
>>  			   const struct i2c_device_id *id)
>>  {
>>  	struct fb_info *info;
>> -	u32 vmem_size = SSD1307FB_WIDTH * SSD1307FB_HEIGHT / 8;
>> +	struct device_node *node = client->dev.of_node;
>> +	u32 vmem_size;
>>  	struct ssd1307fb_par *par;
>>  	u8 *vmem;
>>  	int ret;
>>  
>> -	if (!client->dev.of_node) {
>> +	if (!node) {
> why this will be DT only?
> 
> a platform or ARN that does not support DT can not use this driver
> 
> this looks not right

Because the platform I was developing that for was DT-only, and I guess
if someone wants to use this driver on a non-DT platform, that
hypothetical someone can always send a patch to enable the "old-style"
probing in this driver.

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
