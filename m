Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab3HZHLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 03:11:31 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32604 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509Ab3HZHL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 03:11:29 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-92-521aff9a37f9
Date: Mon, 26 Aug 2013 09:11:14 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Subject: Re: [PATCH v7 1/7] cpufreq: Add boost frequency support in core
Message-id: <20130826091114.78ea4f61@amdc308.digital.local>
In-reply-to: <CAKohpondC1BuODMauBsBKZtL=9sSDUSB6nXFKSoLWJG_xgO+iw@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1376388505-30233-1-git-send-email-l.majewski@samsung.com>
 <1376388505-30233-2-git-send-email-l.majewski@samsung.com>
 <CAKohpo=m=smN-qk45dSdq8SOwAyqtE1xLV-Y85GaCbVhBDsmjQ@mail.gmail.com>
 <20130826090255.01b1f299@amdc308.digital.local>
 <CAKohpondC1BuODMauBsBKZtL=9sSDUSB6nXFKSoLWJG_xgO+iw@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jQd1Z/6WCDM6dl7HYOGM9q8XTph/s
	FvM+y1r0/bzCbLFm/08mi86zT5gtehdcZbN484jb4vKuOWwWn3uPMFrcblzBZtG/sJfJ4snD
	PjaLjV89HPg8Fu95yeRx59oeNo91094ye/RtWcXo8WhxC6PH8RvbmTw+b5ILYI/isklJzcks
	Sy3St0vgyngy+wJTwVTeitbH+1gbGF9wdDFyckgImEj8vnuMGcIWk7hwbz1bFyMXh5DAdEaJ
	FxdPMUE47UwSi2e8BatiEVCVuPTrByOIzSagJ/H57lOgIg4OEQEtiZc3U0HqmQV2skgse3+L
	ESQuLOAh0XI8DqScV8Ba4lLTPlYQm1MgWOLI0WZmiPn/mSS+7/gCluAXkJRo//cD6iI7iXOf
	NrBDNAtK/Jh8jwXEZgbatXlbEyuELS+xec1b5gmMgrOQlM1CUjYLSdkCRuZVjKKpBckFxUnp
	uUZ6xYm5xaV56XrJ+bmbGMEx9Ux6B+OqBotDjAIcjEo8vCuKpIKEWBPLiitzDzFKcDArifC6
	OkgGCfGmJFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQnliSmp2aWpBaBJNl4uCUamBUPDpb
	YJ5+W4UZ45YVP7o5QiTKfqV+ZzKcrzVnxZVrhjw/HP9+CWXc/36+8PnjlQw1XRsaVPI4G38W
	mXxxaEzVuW6/9PpDV0HRlj2TGi6VXHjCYbHowNRvanZzw/tSNPzO/7ri866Sz/xw575NoWl5
	z+yv+CxfrrvZt+Tp9OUJy791+hiaJFkosRRnJBpqMRcVJwIAC7mc6KUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Aug 2013 12:36:47 +0530 Viresh Kumar viresh.kumar@linaro.org
wrote,
> On 26 August 2013 12:32, Lukasz Majewski <l.majewski@samsung.com>
> wrote:
> > On Mon, 26 Aug 2013 10:58:53 +0530 Viresh Kumar
> > viresh.kumar@linaro.org wrote,
> >> Some minor nitpicking, nothing much :)
> >
> > Is there any chance to pull those corrected patches to v3.12?
> 
> Only Rafael can decide :)

:-)

> 
> > After your comments I think, that this code could be rewritten:
> >
> >
> >         list_for_each_entry(policy, &cpufreq_policy_list,
> > policy_list) { freq_table =
> > cpufreq_frequency_get_table(policy->cpu); if (freq_table) {
> >                         ret =
> > cpufreq_frequency_table_cpuinfo(policy, freq_table);
> >                         if (ret) {
> >                                 pr_err("%s: Policy frequency update
> >                                 failed\n")
> 
> Don't break strings into multiple lines even if they cross 80
> columns.. And you missed __func__ :)

C code which turned into the pseudo code :-).

> 
> >                                 break;
> >                         }
> >
> >                         policy->user_policy.max = policy->max;
> >                         __cpufreq_governor(policy,CPUFREQ_GOV_LIMITS);
> >                 }
> >         }
> >
> >         return ret;
> > }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
