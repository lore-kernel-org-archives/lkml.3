Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab3JLK1s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 06:27:48 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:46401 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab3JLK1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 06:27:47 -0400
Message-ID: <5259241F.6060203@gmail.com>
Date: Sat, 12 Oct 2013 12:27:43 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>, m.chehab@samsung.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, s.nawrocki@samsung.com,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/4] media: s5p-tv: Fix mixer driver to work with CCF
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com> <1379775649-6331-5-git-send-email-m.krawczuk@partner.samsung.com> <52430AB6.8020307@samsung.com>
In-Reply-To: <52430AB6.8020307@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 06:09 PM, Tomasz Stanislawski wrote:
> rename to 'media: s5p-tv: mixer: integrate with CCF'
>
> On 09/21/2013 05:00 PM, Mateusz Krawczuk wrote:
>> >  Replace clk_enable by clock_enable_prepare and clk_disable with clk_disable_unprepare.
>> >  Clock prepare is required by Clock Common Framework, and old clock driver didn`t support it.
>> >  Without it Common Clock Framework prints a warning.
>> >
>> >  Signed-off-by: Mateusz Krawczuk<m.krawczuk@partner.samsung.com>
>> >  Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>
> Acked-by: Tomasz Stanislawski<t.stanislaws@samsung.com>

Patch applied with following commit log:

commit 526ec3cc57a0751ff087e93acd1566e6d063fb17
Author: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Date:   Sat Sep 21 14:00:49 2013 +0000

     s5p-tv: mixer: Prepare for common clock framework

     Replace clk_enable() by clock_enable_prepare() and clk_disable()
     with clk_disable_unprepare(). clk_{prepare/unprepare} calls are
     required by common clock framework and this driver was missed while
     converting all users of the Samsung original clocks driver to its
     new implementation based on the common clock API.

     Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
     Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
     Acked-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
     [s.nawrocki@samsung.com: edited commit description]
     Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Regards,
Sylwester
