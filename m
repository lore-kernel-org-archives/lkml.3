Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167Ab3BHO4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:56:21 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52472 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758687Ab3BHO4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:18 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUUedcLAo1OkDSD7K_zgZoLvUAPNYOWAJxSPLp9J3hCKNw@mail.gmail.com>
References: <CA+icZUX-hh+RjEOrKABBtecmb4C-5azSmdTx6D7SLuSpcQE+kQ@mail.gmail.com>
	<CAJd=RBDwdO+n3H4M=5W5q75q3yUVL7L2RonWnCE7sfsfW1K5ig@mail.gmail.com>
	<CA+icZUUaFb8zvdkY2JLz5h_7CBgaTzyyTphGid+GkigV+NfVKA@mail.gmail.com>
	<2612804.Hcyse1lRVO@vostro.rjw.lan>
	<CAKohpom0yjSyU+OhK4vdi5R=+JsmAEw2nOsvupDOiWMYsdz3Pg@mail.gmail.com>
	<CA+icZUUedcLAo1OkDSD7K_zgZoLvUAPNYOWAJxSPLp9J3hCKNw@mail.gmail.com>
Date: Fri, 8 Feb 2013 20:26:16 +0530
X-Google-Sender-Auth: v09S4Vv-zBIGZLhN82-ltAPstSU
Message-ID: <CAOh2x=nn24DC-jpD_UsZ2z6=5d9GmZqwowKF8X0zQQX=vZmbqQ@mail.gmail.com>
Subject: Re: [linux-pm] linux-next: Tree for Feb 8 [ smp|cpufreq: WARNING: at
 kernel/smp.c:245 smp_call_function_single ]
From: Viresh Kumar <viresh.kumar@linaro.org>
To: sedat.dilek@gmail.com
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Hillf Danton <dhillf@gmail.com>, linux-next@vger.kernel.org,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 8, 2013 at 8:18 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> Nah, I pulled in latest pm-next where this commit is new...
>
> commit 8d5666f3456f2fd4a4e5dced228475b829851e53
> "ACPI: Unbind ACPI drv when probe failed"
>
> ...building with it.
>
> Same to you, say concretely which commit is fixing what...
>
> Pull-N-B-Happy was never my strategy... I want to understand what went
> wrong and have stolen my time.

I don't have any pointers to broken tree and so can't point you to the culprit,
but it was this patch:

http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=commit;h=e034e731f4d9d18ad0401f033f485a3096796c58

minus

the patch i sent you as attachment.

There were some locking introduced around init/exit of cpufreq_driver, which
caused some drivers to break. Its fixed now in the above commit.
