Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbaCMOdK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:33:10 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61354 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaCMOdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:33:08 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-b8-5321c1a214bb
Message-id: <1394721184.20773.15.camel@AMDC1943>
Subject: Re: [PATCH] regmap: irq: Set data pointer only on regmap_add_irq_chip
 success
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Mar 2014 15:33:04 +0100
In-reply-to: <20140313141317.GX366@sirena.org.uk>
References: <1394697961-4440-1-git-send-email-k.kozlowski@samsung.com>
 <20140313141317.GX366@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsVy+t/xq7qLDioGG7T/YreY+vAJm0Xz4vVs
	Fpd3zWFzYPbYtKqTzWP/3DXsHp83yQUwR3HZpKTmZJalFunbJXBlLJ23j6Wgl6Piwfv1rA2M
	+9m6GDk5JARMJJbenMMMYYtJXLi3HijOxSEksJRRon3lHSjnM6PErelr2UGqeAUMJNomnWcF
	sYUFIiS2zj/KCGKzCRhLbF6+BGyqiICyxNXve1lAbGaBYIkbx+eDbWARUJX43LGHCcTmFDCU
	+DrxKFCcA2hBrsTJLR4Q5eoSk+YtgjpISWJ3eyc7RFxeYvOat8wQJwhK/Jh8j2UCo8AsJC2z
	kJTNQlK2gJF5FaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIoH7Zwbj4mNUhRgEORiUe3hXL
	FYKFWBPLiitzDzFKcDArifBab1IMFuJNSaysSi3Kjy8qzUktPsTIxMEp1cC4zv2u6qHAldem
	bnlTEpmcXJ4kGet92UtvWWT2ae8Ef+WLkzdnxzhb6u1bESZ//8GGtAOzH5x6zn9jvpSoMGdk
	UV/J10CbME+tRWHPk75Ub3au0tqkH+Io2zDZem7qk2hFx+k3zojOsM5Z/rVz/+uQ6FeH0h46
	VHWfLPDovMc/Jaam3urvunQlluKMREMt5qLiRAD2xkKlMgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-13 at 14:13 +0000, Mark Brown wrote:
> On Thu, Mar 13, 2014 at 09:06:01AM +0100, Krzysztof Kozlowski wrote:
> > After setting the 'data' pointer (wchich is returned to the caller for
> > freeing later) the regmap_add_irq_chip() could still fail for various
> > reasons (ENOMEM, regmap_read or regmap_write failure). In such case the
> > memory under 'data' was freed in error path and error value was returned
> > but the 'data' variable was not changed.
> > 
> > This could lead to errors if the caller passed such 'data' to
> > regmap_del_irq_chip().
> 
> If the user is calling regmap_del_irq_chip() after the add failed then
> I'd expect things to break anyway...

Yes, you're right but still I think that 'data' should be set in a
atomic way - only if regmap_add_irq_chip() succeeds. Usually a caller
passing a pointer for allocation expects that one of:
1. Allocation succeeds and it is put under passed pointer;
2. Allocation fails and no one touches my pointer.


Best regards,
Krzysztof

