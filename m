Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934579Ab3BTKUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:20:35 -0500
Received: from mail.ispras.ru ([83.149.199.45]:40122 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934384Ab3BTKUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:20:33 -0500
Message-ID: <5124A360.8070208@ispras.ru>
Date: Wed, 20 Feb 2013 14:20:16 +0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Manu Abraham <manu@linuxtv.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] [media] stv090x: do not unlock unheld mutex in stv090x_sleep()
References: <1361300333-9410-1-git-send-email-khoroshilov@ispras.ru> <CAHFNz9+RnXh3AeSn70mpP-Z=26=MCZDtGPHnr67U++i7X6ELOA@mail.gmail.com>
In-Reply-To: <CAHFNz9+RnXh3AeSn70mpP-Z=26=MCZDtGPHnr67U++i7X6ELOA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 10:58 AM, Manu Abraham wrote:
> Hi,
>
> On Wed, Feb 20, 2013 at 12:28 AM, Alexey Khoroshilov
> <khoroshilov@ispras.ru> wrote:
>> goto err and goto err_gateoff before mutex_lock(&state->internal->demod_lock)
>> lead to unlock of unheld mutex in stv090x_sleep().
> Out of curiosity, what happens when you try to unlock an unlocked mutex ?
>
> Regards,
> Manu
>
Bad things can happen if someone else holds the mutex and it becomes
unexpectedly unlocked.
Also it can result that the next lock() operation leaves the mutex in
unlocked state.
The both cases can lead to data races with unpredictable consequences.

--
Alexey Khoroshilov
