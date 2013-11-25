Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab3KYScv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 13:32:51 -0500
Received: from smtp-out.abv.bg ([194.153.145.99]:59220 "EHLO smtp-out.abv.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757318Ab3KYScs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 13:32:48 -0500
DomainKey-Signature: a=rsa-sha1; s=smtp-out; d=abv.bg; c=simple; q=dns;
	b=Z9WNiYvWjFFOukWAoi9h0C1kvBEjU4RNfCv1eXZCsOf6tokBJqd0yidsta7OR8rwB
	j4VLPDyQUuyqsJyznLC0WtdK54LsbIQYHU5+RgrP+fWFoCaQq6z/25UTslK2a05uQym
	QF162U4br5sWJCv3dzKeTuyybTzaNUk7kIwXGHA=
Date: Mon, 25 Nov 2013 20:32:46 +0200 (EET)
From: =?UTF-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>
To: Sebastian Reichel <sre@ring0.de>
Cc: pavel@ucw.cz, pali.rohar@gmail.com, anton@enomsg.org, dwmw2@infradead.org,
        tony@atomide.com, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi
Message-ID: <1434978251.31721.1385404366021.JavaMail.apache@mail83.abv.bg>
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for automode
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-Mailer: AbvMail 1.0
X-Originating-IP: 46.249.74.23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  >-------- Оригинално писмо --------
 >От:  Sebastian Reichel 
 >Относно: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for
 automode
 >До: Ивайло Димитров 
 >Изпратено на: Понеделник, 2013, Ноември 25 19:14:21 EET
 >
 >
 >On Mon, Nov 25, 2013 at 07:01:54PM +0200, Ивайло Димитров wrote:
 >>> Now.. Imagine phone left in car in charger (on sun). Likely
 >>> temperature will reach high values, kernel is charging, dsme will
 >>> reboot the system, but kernel will start charging again, dsme will
 >>> reboot again, ...
 >>>
 >>> And it is not only high temperatures that are problem for li-ion
 >>> charging; battery should not be fast charged below 5C and should not
 >>> be charged below 0C. (Again, both are likely to happen if you leave
 >>> your phone in car).
 >>>
 >>> AFAICT, we should simply disable charging below 5C or above 45C.
 >> 
 >> AFAIK dsme will not restart it, but power it off, so the above
 >> scenario won't happen.
 >
 >Just assume what happens, when dsme does not start (e.g. system boot
 >hangs).
 >
 >If everything is controlled from userspace, charger would not start
 >(-> safe!). If everything is controlled by the kernel, temperature
 >safety checks are taken (-> safe!). But in the currently proposed
 >variant: No safety checks.
 >
 >-- Sebastian
 >
 >

Hmm, you have a point here :)

So, AIUI there are 2 options:

1. charger driver polls the battery driver every n (60?) seconds.
2. battery driver sends PSY_EVENT_PROP_CHANGED on every degree up or
down
 
In both cases if the temperature is outside of the safe margins, the
charging should be stopped.

2 seems more generic to me, but as rx51-battery is missing the
functionality to send events on temperature change, I guess 1 will
be easier to implement.

And I think there should be some method (sysfs entry?, /dev/bqxxx
opened?) to tell the charger driver to stop polling the battery 
driver once (and if) the userspace has started to take care of the 
battery temperature - makes no sense to duplicate the checks IMO.

