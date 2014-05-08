Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbaEHB5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 21:57:42 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:45653 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaEHB5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 21:57:39 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1405051147520.28729@gentwo.org>
References: <alpine.DEB.2.10.1405051147520.28729@gentwo.org>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 7 May 2014 18:57:17 -0700
Message-ID: <CAK5ve-+L05fdHzHkL+rcvFk5Y9X5LBnC1kOnFo5FgTop7yysZQ@mail.gmail.com>
Subject: Re: drivers/leds: Replace __get_cpu_var use through this_cpu_ptr
To: Christoph Lameter <cl@linux.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 5, 2014 at 9:48 AM, Christoph Lameter <cl@linux.com> wrote:
> Would you merge this patch please?
>
>

Sure, I merged it to my my tree
Thanks,
-Bryan

> Use this_cpu_ptr for the address calculation instead of __get_cpu_var.
>
> Acked-by: Bryan Wu <cooloney@gmail.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>
>
> Index: linux/drivers/leds/trigger/ledtrig-cpu.c
> ===================================================================
> --- linux.orig/drivers/leds/trigger/ledtrig-cpu.c       2014-04-14 13:24:54.833360823 -0500
> +++ linux/drivers/leds/trigger/ledtrig-cpu.c    2014-04-14 13:24:54.825360977 -0500
> @@ -47,7 +47,7 @@
>   */
>  void ledtrig_cpu(enum cpu_led_event ledevt)
>  {
> -       struct led_trigger_cpu *trig = &__get_cpu_var(cpu_trig);
> +       struct led_trigger_cpu *trig = this_cpu_ptr(&cpu_trig);
>
>         /* Locate the correct CPU LED */
>         switch (ledevt) {
