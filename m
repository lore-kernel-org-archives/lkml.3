Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3LQLEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 06:04:39 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17583 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3LQLEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 06:04:38 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fc96d000006cd4-04-52b02fc4ef8a
Content-transfer-encoding: 8BIT
Message-id: <1387278274.13191.2.camel@AMDC1943>
Subject: Re: [PATCH mfd-next] mfd: max14577 and sec: add PM_SLEEP dependency to
 suspend/resume
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Sangbeom Kim <sbkim73@samsung.com>,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 17 Dec 2013 12:04:34 +0100
In-reply-to: <20131217095300.GA19810@lee--X1>
References: <1387272505-4621-1-git-send-email-k.kozlowski@samsung.com>
 <20131217095300.GA19810@lee--X1>
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xq7pH9DcEGaxYwGxx/+tRRovLu+aw
	WZzuZrW4uOILk8XWvVfZHVg9Gm/cYPO4c20Pm8e8k4EefVtWMXp83iQXwBrFZZOSmpNZllqk
	b5fAlXF92Ur2gq98FY1zlrE1ME7m6WLk5JAQMJFY9fk9E4QtJnHh3nq2LkYuDiGBpYwS3duv
	soMkeAUEJX5MvsfSxcjBwSwgL3HkUjZImFlAXWLSvEXMILaQwGdGidlbQyDK9SXavy4DiwsL
	JEi8XTgFbD6bgLHE5uVL2EDGiAioSJx7Yw6yillgKqPEu/9HWUFqWARUJRrXX2UEsTkFdCWO
	tr+Cmp8pcXfpaTaIO5Ukdrd3sk9gFJiF5LpZCNfNQnLdAkbmVYyiqaXJBcVJ6bmGesWJucWl
	eel6yfm5mxghgfxlB+PiY1aHGAU4GJV4eHfMXx8kxJpYVlyZe4hRgoNZSYT3vO6GICHelMTK
	qtSi/Pii0pzU4kOMTBycUg2Mgavij9YzqT2xywyta7mm82vSngue964U+2S75X03VTMz979+
	f+U6Nk55UympTa++Zlz/XBemERbp8TDZZ6HfL6WtSR2Jbosft202iDB4unjvLPaAPvuspubT
	xt4H6v4pZs3ZOr/+kpGCTxPn2oP2Ij8Lfs5dbqL7RcJw61fP9auN2dUjtz1TYinOSDTUYi4q
	TgQAvNtiGEICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2013-12-17 at 09:53 +0000, Lee Jones wrote:
> On Tue, 17 Dec 2013, Krzysztof Kozlowski wrote:
> 
> > Add CONFIG_PM_SLEEP dependency to suspend and resume functions of
> > max14577 MFD driver and sec-core.c code.
> > 
> > This fixes the warnings:
> > drivers/mfd/max14577.c:176:12: warning: ‘max14577_suspend’ defined but not used [-Wunused-function]
> > drivers/mfd/max14577.c:199:12: warning: ‘max14577_resume’ defined but not used [-Wunused-function]
> > drivers/mfd/sec-core.c:347:12: warning: ‘sec_pmic_suspend’ defined but not used [-Wunused-function]
> > drivers/mfd/sec-core.c:369:12: warning: ‘sec_pmic_resume’ defined but not used [-Wunused-function]
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > ---
> >  drivers/mfd/max14577.c |    2 ++
> >  drivers/mfd/sec-core.c |    2 ++
> >  2 files changed, 4 insertions(+)
> > 
> > diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> > index a5e1c370c609..1018a6644469 100644
> > --- a/drivers/mfd/max14577.c
> > +++ b/drivers/mfd/max14577.c
> > @@ -173,6 +173,7 @@ static const struct i2c_device_id max14577_i2c_id[] = {
> >  };
> >  MODULE_DEVICE_TABLE(i2c, max14577_i2c_id);
> >  
> > +#ifdef CONFIG_PM_SLEEP
> >  static int max14577_suspend(struct device *dev)
> >  {
> >  	struct i2c_client *i2c = container_of(dev, struct i2c_client, dev);
> > @@ -208,6 +209,7 @@ static int max14577_resume(struct device *dev)
> >  
> >  	return 0;
> >  }
> > +#endif /* CONFIG_PM_SLEEP */
> 
> Is this the best way we have of doing this?
> 
> Isn't there a helper which casts these to NULL if unused?

If you are referring to SIMPLE_DEV_PM_OPS then this is already used in
these drivers. It didn't come up in the patch diff because the
SIMPLE_DEV_PM_OPS are used after the line:
static struct of_device_id max14577_dt_match[]


Best regards,
Krzysztof


