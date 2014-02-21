Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbaBUBz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:55:58 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:49075 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbaBUBzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 20:55:49 -0500
MIME-Version: 1.0
In-Reply-To: <53062F97.3050407@wwwdotorg.org>
References: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1392900697-27577-3-git-send-email-heikki.krogerus@linux.intel.com> <53062F97.3050407@wwwdotorg.org>
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 21 Feb 2014 09:55:28 +0800
X-Google-Sender-Auth: o-hq1sFIjmDNB0J39ZUE5sggMAw
Message-ID: <CAGb2v66-tDZhrm9dnXe+PdQTaLZbw20sw3uYzLor2eXpVWmPMA@mail.gmail.com>
Subject: Re: [PATCH 2/4] net: rfkill: gpio: remove gpio names
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Rhyland Klein <rklein@nvidia.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Feb 21, 2014 at 12:38 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 02/20/2014 05:51 AM, Heikki Krogerus wrote:
>> There is no use for them in this driver. This will fix a
>> static checker warning..
>
> Didn't you remove the use:
>
> -       gpio = devm_gpiod_get_index(&pdev->dev, rfkill->reset_name, 0);
> +       gpio = devm_gpiod_get_index(&pdev->dev, NULL, 0);
>
> doesn't that parameter get put into the sysfs GPIO debug file, so people
> can see which GPIOs are used for what?

That's correct. However using con_id to pass this results in different
behavior across DT and ACPI. A better way is to export the labeling
function so consumers can set meaningful labels themselves.


Cheers
ChenYu
