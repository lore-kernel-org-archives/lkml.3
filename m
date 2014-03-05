Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaCEPlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:41:10 -0500
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:59493 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751630AbaCEPlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 10:41:07 -0500
Date: Wed, 5 Mar 2014 16:41:02 +0100
From: Alessandro Zummo <a.zummo@towertech.it>
To: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Cc: David Dajun Chen <david.chen@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RTC linux <rtc-linux@googlegroups.com>
Subject: Re: [RFC V1 2/2] rtc: da9063: RTC driver
Message-ID: <20140305164102.1f8644e4@linux.lan.towertech.it>
In-Reply-To: <649fad1df15ee9f79655bc109282a21e9e9810cf.1394022316.git.stwiss.opensource@diasemi.com>
References: <cover.1394022316.git.stwiss.opensource@diasemi.com>
	<649fad1df15ee9f79655bc109282a21e9e9810cf.1394022316.git.stwiss.opensource@diasemi.com>
Organization: Tower Technologies
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014 12:25:16 +0000
"Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com> wrote:

> +	if (IS_ERR(rtc->rtc_dev)) {
> +		ret = PTR_ERR(rtc->rtc_dev);
> +		goto err;
> +	}

 please,

  return PTR_ERR(....) 

> +
> +	irq_alarm = platform_get_irq_byname(pdev, "ALARM");
> +	ret = devm_request_threaded_irq(&pdev->dev, irq_alarm, NULL,
> +					da9063_alarm_event,
> +					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> +					"ALARM", rtc);
> +	if (ret)
> +		dev_err(&pdev->dev, "Failed to request ALARM IRQ %d: %d\n",
> +			irq_alarm, ret);
> +
> +	da9063_data_to_tm(data, &rtc->alarm_time);
> +	rtc->rtc_sync = false;
> +err:
> +	return ret;
> +}

   if the interrupt is mandatory you should request it before registering
  the rtc device. if it isn't, please return 0.


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

