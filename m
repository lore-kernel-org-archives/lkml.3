Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965245Ab3FTKF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:05:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57740 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab3FTKFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:05:25 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-26-51c2d3e494d4
Date: Thu, 20 Jun 2013 12:04:58 +0200
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH v3 1/3] cpufreq: Add boost frequency support in core
Message-id: <20130620120458.4f2230f1@amdc308.digital.local>
In-reply-to: <CAKohponVBjvQf-5BibzDUko=fVtzPYWMOr2xywp=r0TTB_t6Bw@mail.gmail.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <20130617155156.4c729b5a@amdc308.digital.local>
 <CAKohpo=_=u35wTb-ZUXrR2hNno+ryAqq4gSC3EiJr=-bmgb9JQ@mail.gmail.com>
 <3258927.Qds4G9CTyG@vostro.rjw.lan>
 <CAKohponVBjvQf-5BibzDUko=fVtzPYWMOr2xywp=r0TTB_t6Bw@mail.gmail.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42I5/e+xgO6Ty4cCDWb+ErBouBpi8eftclaL
	p00/2C3mfZa16Dz7hNmid8FVNos3j7gtLu+aw2bxufcIo8XtxhVsFv0Le5ksOo58Y7bY+NXD
	gdfjzrU9bB7rpr1l9ujbsorR49HiFkaPz5vkAlijuGxSUnMyy1KL9O0SuDLa9+1iLdjFUbHp
	7DzWBsZzbF2MnBwSAiYSXd/Ps0PYYhIX7q0HinNxCAksYpT41PiFEcJpZ5I42DuJFaSKRUBV
	4vfTs8wgNpuAnsTnu0+ZQGwRAV+JRYs2M4E0MAt8YZbY+Xs6WEJYwEPi3JFpjCA2r4C1xKW1
	64DiHBycAsESu49bQyxYzSRxcsNdsBp+AUmJ9n8/mCFOspM492kDO0SvoMSPyfdYQGxmAS2J
	zduaWCFseYnNa94yT2AUnIWkbBaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93E
	CI6aZ9I7GFc1WBxiFOBgVOLh1bh8MFCINbGsuDL3EKMEB7OSCG/qnEOBQrwpiZVVqUX58UWl
	OanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhhLJbUiXVgvlFaeTV14weDg41fn
	+d46zWTZsmHHQ5v6dPMzs0ql9u53DXWL4y9pCPAV6Q2Uuhy841V7TsTD4JYbrd+eGXxzMj/+
	9ueui4y16nX6nr2cWQbZ4g3nljpZT92RwbBY15g3YMJqBcOzcwxL1j1b6ppbrzN1SQaHV/em
	s08LpsbMmabEUpyRaKjFXFScCACU5TZnlgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013 10:31:30 +0530, Viresh Kumar wrote:
> > I'd say there needs to be a separate controller/monitor for that
> > that will know what the chip's thermal limit is and how that
> > relates to how fast the CPU core(s) may run and for how much time.
> > I'm not sure it is sufficient to "wait for thermal to kick in"
> > here, because you may need to slow down things in advance (i.e.
> > before thermal sensors tell you there's too much heat, because that
> > may be too late already).  
> 
> That's why I wasn't sure about software boosting initially. But at
> the same time a thermal sensor might be good enough. They just have
> to be programmed accordingly, so that they fire a bit in advance
> before things are out of control. :)

I think that thermal subsystem shall disable boost when SoC is heated
up.

The problem is to guarantee, that thermal will be always enabled and
correctly configured when software based boost is ready to run.


-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
