Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbaCTJdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:33:35 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:54493 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757539AbaCTJd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:33:29 -0400
MIME-Version: 1.0
In-Reply-To: <532AB3E7.3090503@linux.vnet.ibm.com>
References: <2efc621827cbd96a05a3d34075154974b4816ecd.1394782795.git.viresh.kumar@linaro.org>
	<532840FD.308@linux.vnet.ibm.com>
	<CAKohpomhTJa06a1LSi9tK1+=6Y2MyidJSbYWuffAsU5KxVf7zw@mail.gmail.com>
	<53296870.5010505@linux.vnet.ibm.com>
	<CAKohpomr1s3SLs-K8+-BKguX4PyfHvSjyzd5PFjM4mJeyTj3-A@mail.gmail.com>
	<53298A7D.3080400@linux.vnet.ibm.com>
	<CAKohpon=VLfPiukzrtQOSVAQg-Z-Aq3+AkZ1myrE6XtVRMY8mQ@mail.gmail.com>
	<532AA7A8.3040508@linux.vnet.ibm.com>
	<CAKohpon-i7LUqALr3Bi1Sn02m93YZpBn3sjmDdo3VQCuW5bNYw@mail.gmail.com>
	<532AB3E7.3090503@linux.vnet.ibm.com>
Date: Thu, 20 Mar 2014 15:03:28 +0530
Message-ID: <CAKohpokiDYqpTj0AbR17KDbE26E=5usRuLWg0+pLR0xR5e5xTg@mail.gmail.com>
Subject: Re: [RFC v3] cpufreq: Make sure frequency transitions are serialized
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Daniel <amit.daniel@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 March 2014 14:54, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> On 03/20/2014 02:07 PM, Viresh Kumar wrote:
>>     WARN_ON(policy->transition_ongoing);
>>
>
> I guess you meant WARN_ON(!policy->transition_ongoing)
> perhaps?

Ooops!!

> I'm not sure whether its really worth it, because it kinda looks
> obvious. Not sure what kind of bugs it would catch. I can't think of any
> such scenario :-(

Just to catch if somebody is sending a POSTCHANGE one without first
sending a PRECHANGE one.. Just another check to make sure things are
in order.
