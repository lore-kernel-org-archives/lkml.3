Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311Ab3FFI6d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 04:58:33 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25104 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264Ab3FFI60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 04:58:26 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-02-51b04f317709
Date: Thu, 06 Jun 2013 10:58:14 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocky" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH 1/5] cpufreq: Define cpufreq_set_drv_attr_files() to add
 per CPU sysfs attributes
Message-id: <20130606105814.3495e3a9@amdc308.digital.local>
In-reply-to: <CAKohpokYdwutUX-zkHLs3bKmLg=Fb7WvKcwvfek9Q8k=XXs3bw@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1370502472-7249-2-git-send-email-l.majewski@samsung.com>
 <CAKohpokYdwutUX-zkHLs3bKmLg=Fb7WvKcwvfek9Q8k=XXs3bw@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t9jQV1D/w2BBssvCVr8ebuc1eJp0w92
	i3mfZS06zz5htnjziNvi/aFnzBaXd81hs/jce4TR4nbjCjaL/oW9TBYdR74xW2z86uHA43Hn
	2h42j9v/HjN7rJv2ltmjb8sqRo9Hi1sYPT5vkgtgi+KySUnNySxLLdK3S+DKODH1BFPBL6GK
	l6flGxhP83UxcnJICJhIvF54jBnCFpO4cG89WxcjF4eQwHRGiftfvrCBJIQE2pkkzm/wBbFZ
	BFQlZmy8C9bAJqAn8fnuU6YuRg4OEQEtiZc3U0F6mQV+MUu0vFrADBIXFkiXeLXNAsTkFbCW
	aGksBzE5BYIlVk7xhNh0glHi1ZtLYBP5BSQl2v/9gDrHTuLcpw3sIDavgKDEj8n3WEBsZqBN
	m7c1sULY8hKb17xlnsAoOAtJ2SwkZbOQlC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJ
	ERwtz6R3MK5qsDjEKMDBqMTDKxGwPlCINbGsuDL3EKMEB7OSCO8unw2BQrwpiZVVqUX58UWl
	OanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhg97C0P16xn1jHfOtciePpn+bnC
	34/a1n0NyfO2mde2+8U0j+e2zrX1NuIPH7K0qIf+y1vW3u/wx0nn5tkzz713SIudTCvYbyFg
	tnTuiod6oZ7WdxjfWM1TeXqeZeP2i30zvhndXH9704qamQEP1OfqHM41ZNTeWF+iefeZcPNe
	0/Jrh7YfWNCuxFKckWioxVxUnAgAIynDRpICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Viresh,

> On 6 June 2013 12:37, Lukasz Majewski <l.majewski@samsung.com> wrote:
> 
> > Subject: cpufreq: Define cpufreq_set_drv_attr_files() to add per
> > CPU sysfs attributes
> 
> Its not per-cpu. We just add it for policy->cpu and other routines
> actually create links.
> 
> > The cpufreq_set_drv_attr_files() function creates sysfs file entry
> > for each available CPU. With it in place it is possible to add
> > different set of attributes without code duplication.
> 
> Not for each available cpu but are linked to a policy->kobj and so
> shows up on each policy->cpus.

Yes, you are right here. Thanks for detailed explanation. Being
"per-cpu" comes from kobj embedded at policy, which has information
about cpus affected. 

> 
> > Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> > Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> > ---
> >  drivers/cpufreq/cpufreq.c |   23 +++++++++++++++--------
> >  1 file changed, 15 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> > index 1b8a48e..ca74e27 100644
> > --- a/drivers/cpufreq/cpufreq.c
> > +++ b/drivers/cpufreq/cpufreq.c
> > @@ -730,12 +730,23 @@ static int cpufreq_add_dev_symlink(unsigned
> > int cpu, return ret;
> >  }
> >
> > +static int cpufreq_set_drv_attr_files(struct cpufreq_policy
> > *policy,
> > +                                     struct freq_attr **drv_attr)
> > +{
> > +       while ((drv_attr) && (*drv_attr)) {
> > +               if (sysfs_create_file(&policy->kobj,
> > &((*drv_attr)->attr)))
> > +                       return 1;
> 
> You are changing the semantics here. We used to return error
> value from sysfs_create_file() and you are returning 1.

Yes, correct. The ret from sysfs_create_file shall be returned.
Returning 1 causes information lost.

> 
> > +               drv_attr++;
> 
> If drv_attr was valid initially, then drv_attr++ can't make it NULL.
> So, we don't need to check validity of drv_attr for every loop.

I'm confused here. 

So you want to check dev_attr for NULL just after:
drv_attr = cpufreq_driver->attr;
if (!drv_attr)
	goto error;

and skip the check at the while loop:
while ((drv_attr) && (*drv_attr)) 

to 

while ((*drv_attr))

Am I correct?


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
