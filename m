Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaJ0PfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:35:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbaJ0PfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:35:07 -0400
Date: Mon, 27 Oct 2014 16:33:58 +0100
From: Jean Delvare <jdelvare@suse.de>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux@roeck-us.net,
        lm-sensors@lm-sensors.org
Subject: Re: randconfig build error with next-20141027, in
 drivers/hwmon/i5500_temp.c
Message-ID: <20141027163358.1754a025@endymion.delvare>
In-Reply-To: <CA+r1ZhiTncfpV9wekBK363OmJCHeCfYj6o9o7QkkHCR3H1VhXQ@mail.gmail.com>
References: <CA+r1ZhiTncfpV9wekBK363OmJCHeCfYj6o9o7QkkHCR3H1VhXQ@mail.gmail.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jim,

On Mon, 27 Oct 2014 07:50:09 -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
>   CC [M]  drivers/hwmon/i5500_temp.o
> drivers/hwmon/i5500_temp.c:145:1: warning: data definition has no type
> or storage class [enabled by default]
>  module_pci_driver(i5500_temp_driver);
>  ^
> drivers/hwmon/i5500_temp.c:145:1: error: type defaults to ‘int’ in
> declaration of ‘module_pci_driver’ [-Werror=implicit-int]
> drivers/hwmon/i5500_temp.c:145:1: warning: parameter names (without
> types) in function declaration [enabled by default]
> drivers/hwmon/i5500_temp.c:139:26: warning: ‘i5500_temp_driver’
> defined but not used [-Wunused-variable]
>  static struct pci_driver i5500_temp_driver = {
>                           ^
> cc1: some warnings being treated as errors
> make[2]: *** [drivers/hwmon/i5500_temp.o] Error 1

Thanks for the report. The driver should obviously depend on
CONFIG_PCI, not sure how I managed to miss that :( I'll fix it
immediately.

-- 
Jean Delvare
SUSE L3 Support
