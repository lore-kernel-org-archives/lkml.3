Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab3GXGQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 02:16:07 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:32977 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab3GXGQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 02:16:04 -0400
MIME-Version: 1.0
In-Reply-To: <51EF70B4.2010806@samsung.com>
References: <1374146275-5758-1-git-send-email-cw00.choi@samsung.com>
	<1374146275-5758-2-git-send-email-cw00.choi@samsung.com>
	<CAKohpo=oTsEjzi_51UaZ8ww8UEfZ6hwKAnu9rFgGBkt=TfHi8A@mail.gmail.com>
	<51EF2D06.7000704@samsung.com>
	<51EF70B4.2010806@samsung.com>
Date: Wed, 24 Jul 2013 11:46:03 +0530
X-Google-Sender-Auth: fS5sj0WdzXf6hSRGiQTJU9YPfP0
Message-ID: <CAOh2x==uh1y+9h0B0X+VbzDx9UDuNPu7OogwAoGqYwJ3CBg06g@mail.gmail.com>
Subject: Re: [PATCH 1/3 v6] cpufreq: Add debugfs directory for cpufreq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, kyungmin.park@samsung.com,
        myungjoo.ham@samsung.com,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 11:44 AM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> I considered the parameter type of cpufreq_create_debugfs_symlink() and then
> I need following function declaration because this function didn't always need to
> create symbolic link to policy->cpu. This function declaration is capable of creating
> symbolic link as 'dest_cpu -> src_cpu'
>
>         +static int cpufreq_create_debugfs_symlink(unsigned int src_cpu,
>         +                                          unsigned int dest_cpu)

You need policy structure as well, right? And src_cpu is always going to
be policy->cpu. So you can have policy and cpu as two parameters.. cpu
is dest cpu btw.
