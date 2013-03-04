Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab3CDKBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:01:48 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:54261 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016Ab3CDKBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:01:45 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: wsa@the-dreams.de, ben-linux@fluff.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "Maxin B. John" <maxin.john@enea.com>
Subject: Re: [PATCH] i2c: busses: i2c-ocores: Fix PM-related warning
References: <1361915625-24294-1-git-send-email-maxin.john@gmail.com>
	<CAMhs6Yy+CFB-dC7PKCEn=19JbiKz=DqWW1G=QeLUzTvwakE_rg@mail.gmail.com>
Date: Mon, 04 Mar 2013 11:01:40 +0100
In-Reply-To: <CAMhs6Yy+CFB-dC7PKCEn=19JbiKz=DqWW1G=QeLUzTvwakE_rg@mail.gmail.com>
	(Maxin B. John's message of "Mon, 4 Mar 2013 10:18:20 +0100")
Message-ID: <87ppzfcwl7.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Maxin" == Maxin B John <maxin.john@gmail.com> writes:

 Maxin> On Tue, Feb 26, 2013 at 10:53 PM,  <maxin.john@gmail.com> wrote:
 >> From: "Maxin B. John" <maxin.john@enea.com>
 >> 
 >> Fixes this warning:
 >> CC      drivers/i2c/busses/i2c-ocores.o
 >> drivers/i2c/busses/i2c-ocores.c:460:12: warning: 'ocores_i2c_suspend'
 >> defined but not used [-Wunused-function]
 >> drivers/i2c/busses/i2c-ocores.c:471:12: warning: 'ocores_i2c_resume'
 >> defined but not used [-Wunused-function]
 >> 
 >> Signed-off-by: Maxin B. John <maxin.john@enea.com>
 >> ---
 >> drivers/i2c/busses/i2c-ocores.c |    9 +++------
 >> 1 files changed, 3 insertions(+), 6 deletions(-)
 >> 
 >> diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
 >> index 0e1f824..1ecea5e 100644
 >> --- a/drivers/i2c/busses/i2c-ocores.c
 >> +++ b/drivers/i2c/busses/i2c-ocores.c
 >> @@ -456,7 +456,7 @@ static int ocores_i2c_remove(struct platform_device *pdev)
 >> return 0;
 >> }
 >> 
 >> -#ifdef CONFIG_PM
 >> +#ifdef CONFIG_PM_SLEEP
 >> static int ocores_i2c_suspend(struct device *dev)
 >> {
 >> struct ocores_i2c *i2c = dev_get_drvdata(dev);
 >> @@ -476,12 +476,9 @@ static int ocores_i2c_resume(struct device *dev)
 >> 
 >> return 0;
 >> }
 >> +#endif
 >> 
 >> static SIMPLE_DEV_PM_OPS(ocores_i2c_pm, ocores_i2c_suspend,
 >> ocores_i2c_resume);

A comment explaining that the suspend/resume callbacks are unused in the
!PM_SLEEP mode would be good.

With this change we waste ~100 bytes on a dummy dev_pm_ops structure,
but OK.


 >> -#define OCORES_I2C_PM  (&ocores_i2c_pm)
 >> -#else
 >> -#define OCORES_I2C_PM  NULL
 >> -#endif
 >> 
 >> static struct platform_driver ocores_i2c_driver = {
 >> .probe   = ocores_i2c_probe,
 >> @@ -490,7 +487,7 @@ static struct platform_driver ocores_i2c_driver = {
 >> .owner = THIS_MODULE,
 >> .name = "ocores-i2c",
 >> .of_match_table = ocores_i2c_match,
 >> -               .pm = OCORES_I2C_PM,
 >> +               .pm = &ocores_i2c_pm,
 >> },
 >> };
 >> 
 >> --
 >> 1.7.7
 >> 

 Maxin> ping..


-- 
Bye, Peter Korsgaard
