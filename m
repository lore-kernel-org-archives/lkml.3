Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3EUAeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 20:34:21 -0400
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:48728 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682Ab3EUAeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 20:34:20 -0400
Date: Tue, 21 May 2013 08:42:31 +0900
From: Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
To: matt.henry.stuart@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux doesn't create /proc/vmcore
Message-Id: <20130521084231.b7f99cbfae24b0e773c48d79@mxc.nes.nec.co.jp>
In-Reply-To: <CANeS4r2Zu=1496Te41jTrNDAGL1VsOgNmLNVZS6wrBOmn0-eWw@mail.gmail.com>
References: <CANeS4r2Zu=1496Te41jTrNDAGL1VsOgNmLNVZS6wrBOmn0-eWw@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello matt,

> CONFIG_PROC_VMCORE=y

Is it specified for the capture kernel ?
By any chance, did you run kdump-config on the system kernel,
not on the capture kernel ?

> DESCRIPTION
>       kdump-config manages the kdump feature of the  Linux  kernel.   When  a
>       kdump  enabled  kernel panics, it immediately boots into a clean kernel
>       called the kdump kernel.  The memory image of the panicked kernel  will
>       be  presented  in  /proc/vmcore  while  the  kdump  kernel (or "capture
>       kernel") is running.

/proc/vmcore doesn't be created on the system kernel, this tool should be
run on the capture kernel.

And this document may help you:

  Documentation/kdump/kdump.txt


Thanks
Atsushi Kumagai

> 
> my error on the kdump:
> kdump-config savecore
> running makedumpfile -c -d 31 /proc/vmcore
> /var/crash/201305180259/dump-incomplete.
> open_dump_memory: Can't open the dump memory(/proc/vmcore). No such
> file or directory
> 
> makedumpfile Failed.
> kdump-config: makedumpfile failed, falling back to 'cp' ... failed!
> cp: cannot stat `/proc/vmcore': No such file or directory
> kdump-config: failed to save vmcore in /var/crash/201305180259 ... failed!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
