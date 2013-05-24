Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab3EXWdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 18:33:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab3EXWdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 18:33:42 -0400
Message-ID: <1369434846.8000.9.camel@dcbw.foobar.com>
Subject: Re: [PATCH] serial: Add Option GTM681W to qcserial device table.
From: Dan Williams <dcbw@redhat.com>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Richard Weinberger <richard@nod.at>, gregkh@linuxfoundation.org,
        jhovold@gmail.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 24 May 2013 17:34:06 -0500
In-Reply-To: <87ehcwfd6m.fsf@nemi.mork.no>
References: <1369389711-4290-1-git-send-email-richard@nod.at>
	 <87obc0frdu.fsf@nemi.mork.no> <519F88CB.4020500@nod.at>
	 <87ehcwfd6m.fsf@nemi.mork.no>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-24 at 20:25 +0200, Bjørn Mork wrote:
> Richard Weinberger <richard@nod.at> writes:
> > Am 24.05.2013 15:18, schrieb Bjørn Mork:
> >> Richard Weinberger <richard@nod.at> writes:
> >>
> >>> The Option GTM681W uses a qualcomm chip and can be
> >>> served by the qcserial device driver.
> >>
> >> Should it also be added to the qmi_wwan driver?
> >
> > Don't know. But I can happily test it. :)
> > Can you please explain me how to use the qmi_wwan driver?
> > I've never used it.
> 
> The QMI management protocol is delegated to userspace using a
> /dev/cdc-wdmX character device.  So you need a userspace component to
> test the driver, like for example libqmi. See 
> http://sigquit.wordpress.com/2012/08/20/an-introduction-to-libqmi/ for a
> short intro.

Various marketing collateral suggests the 681W is a Gobi3K and thus it
most certainly should also get added to qmi_wwan.  lsusb -v output for
it would be helpful too I think?

http://www.option.com/product/gtm681wgtm689w/

Dan

> This library is packaged in Debian.  Don't know the status of other
> distros. 
> 
> The driver supports dynamic device IDs, so if you have qcserial bound to
> all serial ports, and there is a QMI interface with no driver bound yet,
> then testing should be as easy as
> 
>  modprobe qmi_wwan
>  echo "0af0 8120" >/sys/bus/usb/drivers/qmi_wwan/new_id
>  qmicli -d /dev/cdc-wdm0 --dms-get-manufacturer
> 
> 
> 
> Bjørn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


