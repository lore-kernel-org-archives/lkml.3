Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571Ab3E1K2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:28:40 -0400
Received: from canardo.mork.no ([148.122.252.1]:45399 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617Ab3E1K2i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:28:38 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Bruce <bruce.ma@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        linux-kernel@vger.kernel.org
Subject: Re: Patch for thinkpad-acpi.c
Organization: m
References: <51A47773.4080701@canonical.com>
Date: Tue, 28 May 2013 12:28:19 +0200
In-Reply-To: <51A47773.4080701@canonical.com> (Bruce's message of "Tue, 28 May
	2013 17:22:59 +0800")
Message-ID: <87r4gr9z5o.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruce <bruce.ma@canonical.com> writes:

> +struct blacklist lenovo_blacklist[] = {
> +  {
> +    .model_s = "Lenovo LM490s",
> +    .nummodel_s = "814YG01",
> +  },


The driver already has a list of LED support per model in the 

  static const struct tpacpi_quirk led_useful_qtable[] __initconst = {}

array.   Why do you duplicate this with lots of new model checking code
instead of just using the code that's already there?

>  static void led_exit(void)
>  {
> +        if (no_led == 1 ) {


The driver already has provisions for signalling that LEDs are
unsupported through the 'led_supported' variable.  Why do you add
another variable, and duplicate testing in every access function?

But I don't think this part is needed at all, as long as you set up the
proper LED map in led_useful_qtable.



Bjørn
