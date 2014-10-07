Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaJGKHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:07:49 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38521 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaJGKHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:07:46 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Robert Baldyga <r.baldyga@samsung.com>, balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrzej.p@samsung.com,
        k.opasiak@samsung.com, Robert Baldyga <r.baldyga@samsung.com>
Subject: Re: [PATCH v2] usb: gadget: f_fs: add "zombie" mode
In-Reply-To: <1412668742-14831-1-git-send-email-r.baldyga@samsung.com>
Organization: http://mina86.com/
References: <1412668742-14831-1-git-send-email-r.baldyga@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141007:gregkh@linuxfoundation.org::1WQYS5dtxorCEnNa:000000000000000000000000000000000000aNb
X-Hashcash: 1:20:141007:balbi@ti.com::1IDsSUuMzoBtN3K7:000001SxF
X-Hashcash: 1:20:141007:r.baldyga@samsung.com::+sby5DA+IHj+8q9y:00000000000000000000000000000000000000002Tpd
X-Hashcash: 1:20:141007:linux-kernel@vger.kernel.org::QumyhCfqFP3bnltR:0000000000000000000000000000000003AtH
X-Hashcash: 1:20:141007:k.opasiak@samsung.com::60qrodrSVRgERAmF:000000000000000000000000000000000000000034MM
X-Hashcash: 1:20:141007:r.baldyga@samsung.com::cxnMz5NtkI7aQkTb:00000000000000000000000000000000000000003V/u
X-Hashcash: 1:20:141007:andrzej.p@samsung.com::TikIhH/cuymAnhld:0000000000000000000000000000000000000000AXMR
X-Hashcash: 1:20:141007:linux-usb@vger.kernel.org::u6x71rh+W2NxCSrh:000000000000000000000000000000000000FgZy
Date: Tue, 07 Oct 2014 12:07:41 +0200
Message-ID: <xa1t61fwyyz6.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07 2014, Robert Baldyga <r.baldyga@samsung.com> wrote:
> @@ -1411,8 +1425,17 @@ static void ffs_data_closed(struct ffs_data *ffs)
>  	ENTER();
>  
>  	if (atomic_dec_and_test(&ffs->opened)) {
> -		ffs->state = FFS_CLOSING;
> -		ffs_data_reset(ffs);
> +		if (ffs->zombie_mode) {
> +			ffs->state = FFS_ZOMBIE;
> +			if (ffs->epfiles)
> +				ffs_epfiles_delete(ffs->epfiles,
> +						   ffs->eps_count);

This looks suspicious.  Why isn't it:

+			if (ffs->epfiles) {
+				ffs_epfiles_destroy(ffs->epfiles,
+						   ffs->eps_count);
+				ffs->epfiles = NULL;
+			}

If ffs->epfiles is not NULLed, call to ffs_data_reset in ffs_data_open
will call ffs_epfiles_destroy which we don't want, do we?

> +			if (ffs->setup_state == FFS_SETUP_PENDING)
> +				__ffs_ep0_stall(ffs);
> +		} else {
> +			ffs->state = FFS_CLOSING;
> +			ffs_data_reset(ffs);
> +		}
>  	}
>  
>  	ffs_data_put(ffs);

> @@ -93,6 +93,26 @@ enum ffs_state {
>  	FFS_ACTIVE,
>  
>  	/*
> +	 * Function is visible to host, but it's not functional. All
> +	 * setup requests are stalled and another transfers are refused.

“and transfers on other endpoints are refused.”

> +	 * All epfiles, excepting ep0, are deleted so there is no way

s/excepting/except/

> +	 * to perform any operations on them.
> +	 *
> +	 * This state is set after closing all functionfs files, when
> +	 * mount parameter "zombie=1" has been set. Function will remain
> +	 * in zombie state until filesystem will be umounted or ep0 will

s/will be umounted/is unmounted/
s/ep0 will be/ep0 is/

> +	 * be opened again. In the second case functionfs state will be
> +	 * reseted, and it will be ready for descriptors and strings

s/reseted/reset/

> +	 * writing.
> +	 *
> +	 * This is useful only when functionfs is composed to gadget
> +	 * with another function which can perform some critical
> +	 * operations, and it's strongly desired to have this operations
> +	 * completed, even after functionfs files closure.
> +	 */
> +	FFS_ZOMBIE,
> +
> +	/*
>  	 * All endpoints have been closed.  This state is also set if
>  	 * we encounter an unrecoverable error.  The only
>  	 * unrecoverable error is situation when after reading strings

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
