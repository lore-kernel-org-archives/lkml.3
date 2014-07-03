Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759199AbaGCRUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:20:36 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:50177 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaGCRUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:20:35 -0400
MIME-Version: 1.0
In-Reply-To: <53B55FA6.5080801@cogentembedded.com>
References: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
 <1404393762-858019-6-git-send-email-manuel.lauss@gmail.com> <53B55FA6.5080801@cogentembedded.com>
From: Manuel Lauss <manuel.lauss@gmail.com>
Date: Thu, 3 Jul 2014 19:19:52 +0200
Message-ID: <CAOLZvyFit=cuXHjtx=v2oOBAdj9yj1nwODzBQ+3EP7MpongZoA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 05/11] MIPS: Alchemy: pci: use clk framework to
 enable PCI clock
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Linux-MIPS <linux-mips@linux-mips.org>,
        Mike Turquette <mturquette@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,

On Thu, Jul 3, 2014 at 3:50 PM, Sergei Shtylyov
<sergei.shtylyov@cogentembedded.com> wrote:
>> --- a/arch/mips/pci/pci-alchemy.c
>> +++ b/arch/mips/pci/pci-alchemy.c
>> @@ -394,11 +396,24 @@ static int alchemy_pci_probe(struct platform_device
>> *pdev)

>> +       ret = clk_prepare_enable(c);
>> +       if (ret) {
>> +               dev_err(&pdev->dev, "cannot enable PCI clock\n");
>> +               clk_put(c);
>> +               goto out2;
>
>
>    Isn't it simpler to add one more label before clk_put() at end of
> function?

Yes, I have changed it locally.


Thank you!
       Manuel
