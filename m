Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab3JHM5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:57:44 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:61181 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab3JHM5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:57:40 -0400
MIME-Version: 1.0
In-Reply-To: <1381236524-19633-1-git-send-email-felipe.contreras@gmail.com>
References: <1381236524-19633-1-git-send-email-felipe.contreras@gmail.com>
Date: Tue, 8 Oct 2013 07:57:38 -0500
Message-ID: <CAMP44s0ShT6+msCm0T+cpwzktzQZ9OtD2MOXg3AQACkyjB92GQ@mail.gmail.com>
Subject: Re: [PATCH v2] platform: x86: asus-wmi: add fan control
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "open list:ASUS NOTEBOOKS AN..." 
	<platform-driver-x86@vger.kernel.org>,
        "open list:ASUS NOTEBOOKS AN..." 
	<acpi4asus-user@lists.sourceforge.net>,
        Linux PM <linux-pm@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 8, 2013 at 7:48 AM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> Simple driver to enable control of the fan in ASUS laptops. So far this
> has only been tested in ASUS Zenbook Prime UX31A, but according to some
> online reference [1], it should work in other models as well.
>
> The implementation is very straight-forward, the only caveat is that the
> fan speed needs to be saved after it has been manually changed because
> it won't be reported properly until it goes back to 'auto' mode.
>
> [1] http://forum.notebookreview.com/asus/705656-fan-control-asus-prime-ux31-ux31a-ux32a-ux32vd.html
>
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>

> +       r = asus_wmi_evaluate_method(ASUS_WMI_METHODID_AGFN, virt_to_phys(&args), 0, &value);

I don't like using virt_to_phys() here, but it seems that's what the
ACPI code expects.

        Method (AGFN, 1, Serialized)
        {
            If (LEqual (Arg0, Zero))
            {
                Return (GNBF)
            }

            Store (Zero, Local0)
            OperationRegion (\PARM, SystemMemory, Arg0, 0x08)
            Field (PARM, DWordAcc, NoLock, Preserve)
            {
                MFUN,   16,
                SFUN,   16,
                LEN,    16,
                STAS,   8,
                EROR,   8
            }

Any suggestions?

-- 
Felipe Contreras
