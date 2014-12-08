Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbaLHOWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 09:22:25 -0500
Received: from service87.mimecast.com ([91.220.42.44]:39651 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaLHOWW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 09:22:22 -0500
From: "Javi Merino" <javi.merino@arm.com>
Date: Mon, 8 Dec 2014 14:22:18 +0000
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>, Mark Brown <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Subject: Re: [RFC PATCH v6 6/9] thermal: cpu_cooling: implement the power
 cooling device API
Message-ID: <20141208142217.GA1831@e104805>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
 <1417806260-9264-7-git-send-email-javi.merino@arm.com>
 <CAOh2x==BKyS08th2d4r0Q2UGqhzAwj6sqOgFsH6J0pWup+OU_A@mail.gmail.com>
 <20141208125033.GB2980@e104805>
 <CAKohpokM_8Qm5YH0Xb=n95bP94Qreqpcd1fAyCD2W5u9Pd=ndg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAKohpokM_8Qm5YH0Xb=n95bP94Qreqpcd1fAyCD2W5u9Pd=ndg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 08 Dec 2014 14:22:18.0518 (UTC) FILETIME=[5F5ED360:01D012F2]
X-MC-Unique: 114120814222005601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 01:31:35PM +0000, Viresh Kumar wrote:
> On 8 December 2014 at 18:20, Javi Merino <javi.merino@arm.com> wrote:
> > Is this loop pointless?  I seem to recall that it was needed but I
> > forgot the details.  If you think it is, I can remove it.
> 
> Yes it is pointless. The CPUs you are iterating on, share clock lines
> and so they will have same set of OPPs. Just do this for the cpu
> we are registering the cooling device.

Ok, changed it into:

	cpu = cpumask_any(&cpufreq_device->allowed_cpus);
	dev = get_cpu_device(cpu);
	if (!dev) {
		dev_warn(&cpufreq_device->cool_dev->device,
			"No cpu device for cpu %d\n", cpu);
		ret = -EINVAL;
		goto unlock;
	}

	num_opps = dev_pm_opp_get_opp_count(dev);
	if (num_opps <= 0) {
		ret = (num_opps < 0)? num_opps : -EINVAL;
		goto unlock;
	}

Thanks!
Javi

