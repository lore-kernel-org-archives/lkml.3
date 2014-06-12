Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbaFLB7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:59:51 -0400
Received: from exprod5og124.obsmtp.com ([64.18.0.212]:46486 "HELO
	exprod5og124.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755197AbaFLB7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:59:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140605.004555.658378024391856482.davem@davemloft.net>
References: <1401737954-26152-1-git-send-email-isubramanian@apm.com>
	<1401737954-26152-5-git-send-email-isubramanian@apm.com>
	<20140605.004555.658378024391856482.davem@davemloft.net>
Date: Wed, 11 Jun 2014 18:59:47 -0700
Message-ID: <CAKh23F=F3YOc830v45FavdToOvHEXO7tw6duRvn7-32GUb6cjw@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] drivers: net: Add APM X-Gene SoC ethernet driver support.
From: Iyappan Subramanian <isubramanian@apm.com>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "jcm@redhat.com" <jcm@redhat.com>, patches <patches@apm.com>,
        Ravi Patel <rapatel@apm.com>, Keyur Chudgar <kchudgar@apm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 12:45 AM, David Miller <davem@davemloft.net> wrote:
> From: Iyappan Subramanian <isubramanian@apm.com>
> Date: Mon,  2 Jun 2014 12:39:14 -0700
>
>> +     netdev_err(ndev, "LERR: %d ring_num: %d ", status, ring->num);
>> +     switch (status) {
>> +     case HBF_READ_DATA:
>> +             netdev_err(ndev, "HBF read data error\n");
>> +             break;
>
> This is not really appropriate.
>
> We have statistics like the ones you are incrementing in this
> function as the mechanism people can use to learn what events
> happened on an interface, and how many times they happened.
>
> Therefore, emitting a log message for each one of those events too is
> not necessary.
>
> We don't emit a netdev_err() for every packet that the IPv4 stack
> drops due to a bad checksum, for example.
>
> Please get rid of this.

Sure.  I will remove the error message prints and clean up the function.

>
