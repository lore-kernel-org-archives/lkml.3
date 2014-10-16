Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaJPJQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:16:25 -0400
Received: from regular1.263xmail.com ([211.150.99.137]:44299 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaJPJQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:16:22 -0400
X-Greylist: delayed 78650 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Oct 2014 05:16:22 EDT
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <7e1e6baad8e684dd1d1c498e964827a0>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <543F8CD2.1010302@rock-chips.com>
Date: Thu, 16 Oct 2014 17:16:02 +0800
From: addy ke <addy.ke@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: broonie@kernel.org
CC: heiko@sntech.de, dianders@chromium.org, grant.likely@linaro.org,
        robh+dt@kernel.org, amstan@google.com, sonnyrao@google.com,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, hl@rock-chips.com, wei.luo@rock-chips.com
Subject: Re: [PATCH 1/2] spi/rockchip: fix bug that case spi can't go as fast
 as slave request
References: <1413372311-4203-1-git-send-email-addy.ke@rock-chips.com> <1413372349-4254-1-git-send-email-addy.ke@rock-chips.com> <20141015130452.GD27755@sirena.org.uk>
In-Reply-To: <20141015130452.GD27755@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi, Mark

On 2014/10/15 21:04, Mark Brown wrote:
> On Wed, Oct 15, 2014 at 07:25:49PM +0800, Addy Ke wrote:
> 
>> +	if (WARN_ON(rs->speed > MAX_SCLK_OUT))
>> +		rs->speed = MAX_SCLK_OUT;
>> +
>> +	/* the minimum divsor is 2 */
>> +	if (rs->max_freq < 2 * rs->speed) {
>> +		clk_set_rate(rs->spiclk, 2 * rs->speed);
>> +		rs->max_freq = clk_get_rate(rs->spiclk);
>> +	}
> 
> I'll apply this but you should be checking the return code from
> clk_set_rate() here, please send a followup patch doing that.  It might

If clk_set_rate return error, do I only put dev_warn here or return error value to spi core?

> also be worth consdering just setting the rate unconditionally here, it
> seems like it should make things simpler.
> 
I think we need.
If we set the rate unconditionally here, clk_set_rate() will be executed in each spi transfer.




