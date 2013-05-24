Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab3EXTKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 15:10:15 -0400
Received: from mail47.e.nsc.no ([193.213.115.47]:62192 "EHLO mail47.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab3EXTKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 15:10:14 -0400
X-Greylist: delayed 2692 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 May 2013 15:10:13 EDT
X-Auth: bmork
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Richard Weinberger <richard@nod.at>
Cc: gregkh@linuxfoundation.org, dcbw@redhat.com, jhovold@gmail.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: Add Option GTM681W to qcserial device table.
Organization: m
References: <1369389711-4290-1-git-send-email-richard@nod.at>
	<87obc0frdu.fsf@nemi.mork.no> <519F88CB.4020500@nod.at>
Date: Fri, 24 May 2013 20:25:05 +0200
In-Reply-To: <519F88CB.4020500@nod.at> (Richard Weinberger's message of "Fri,
	24 May 2013 17:35:39 +0200")
Message-ID: <87ehcwfd6m.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> writes:
> Am 24.05.2013 15:18, schrieb Bjørn Mork:
>> Richard Weinberger <richard@nod.at> writes:
>>
>>> The Option GTM681W uses a qualcomm chip and can be
>>> served by the qcserial device driver.
>>
>> Should it also be added to the qmi_wwan driver?
>
> Don't know. But I can happily test it. :)
> Can you please explain me how to use the qmi_wwan driver?
> I've never used it.

The QMI management protocol is delegated to userspace using a
/dev/cdc-wdmX character device.  So you need a userspace component to
test the driver, like for example libqmi. See 
http://sigquit.wordpress.com/2012/08/20/an-introduction-to-libqmi/ for a
short intro.

This library is packaged in Debian.  Don't know the status of other
distros. 

The driver supports dynamic device IDs, so if you have qcserial bound to
all serial ports, and there is a QMI interface with no driver bound yet,
then testing should be as easy as

 modprobe qmi_wwan
 echo "0af0 8120" >/sys/bus/usb/drivers/qmi_wwan/new_id
 qmicli -d /dev/cdc-wdm0 --dms-get-manufacturer



Bjørn
