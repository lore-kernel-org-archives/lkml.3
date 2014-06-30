Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbaF3Tx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 15:53:26 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:48548 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756947AbaF3TxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 15:53:25 -0400
MIME-Version: 1.0
In-Reply-To: <1404157796-13613-2-git-send-email-marek@goldelico.com>
References: <1404157796-13613-1-git-send-email-marek@goldelico.com>
	<1404157796-13613-2-git-send-email-marek@goldelico.com>
Date: Mon, 30 Jun 2014 21:53:24 +0200
Message-ID: <CAAfyv34tGM6ThBfk+0XcGD+4SKbN5w_AA9EUWMBXe7z7qhjSfw@mail.gmail.com>
Subject: Re: [PATCH 2/2] bq27000: report missing device better.
From: Belisko Marek <marek.belisko@gmail.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Sebastian Reichel <sre@kernel.org>
Cc: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Marek Belisko <marek@goldelico.com>, NeilBrown <neilb@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing lkml

On Mon, Jun 30, 2014 at 9:49 PM, Marek Belisko <marek@goldelico.com> wrote:
> One an hdq buss, a missing device reads as 0xff, not -1.
> So do a translation to allow detecting of a missing bus.
>
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  drivers/power/bq27x00_battery.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
> index 27bac1d..aa80efc 100644
> --- a/drivers/power/bq27x00_battery.c
> +++ b/drivers/power/bq27x00_battery.c
> @@ -420,6 +420,9 @@ static void bq27x00_update(struct bq27x00_device_info *di)
>         int flags_changed;
>
>         cache.flags = bq27x00_read(di, BQ27x00_REG_FLAGS, !is_bq27500);
> +       if ((cache.flags & 0xff) == 0xff)
> +               /* read error */
> +               cache.flags = -1;
>         if (cache.flags >= 0) {
>                 if (!is_bq27500 && !is_bq27425
>                                 && (cache.flags & BQ27000_FLAG_CI)) {
> --
> 1.9.1
>



-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
