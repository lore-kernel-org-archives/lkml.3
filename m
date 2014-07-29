Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbaG2Pj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:39:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaG2Pj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:39:56 -0400
Message-ID: <53D7C01B.9060801@redhat.com>
Date: Tue, 29 Jul 2014 11:39:07 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        jhladky@redhat.com, ktkhai@parallels.com, tim.c.chen@linux.intel.com,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 1/2] sched: fix and clean up calculate_imbalance
References: <1406571388-3227-1-git-send-email-riel@redhat.com> <1406571388-3227-2-git-send-email-riel@redhat.com> <CAKfTPtDuFLOf3Kzt4PSdox3HpBoz9aWXb-QzkibAL-Z4xBm=tw@mail.gmail.com> <53D7B551.40703@redhat.com> <CAKfTPtAS-0-9duQgXtri9WxYgFxoKbE05z+4HysCCOS6OaocMQ@mail.gmail.com>
In-Reply-To: <CAKfTPtAS-0-9duQgXtri9WxYgFxoKbE05z+4HysCCOS6OaocMQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/29/2014 11:31 AM, Vincent Guittot wrote:
> On 29 July 2014 16:53, Rik van Riel <riel@redhat.com> wrote:
>> I cannot think of any case where keeping the "overloaded" code
>> would result in the code behaving differently over the long
>> term.
> 
>> What am I overlooking?
> 
> IIUC the load_above_capacity is there to prevent the busiest group
> to become idle and you remove that protection

Having the busiest group become partially idle is perfectly fine,
as long as there is also spare capacity in the destination group.

Spreading out the work load over more CPU sockets, with more CPU
cache and more total available memory bandwidth is often a good
thing.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJT18AbAAoJEM553pKExN6DaLoH/RzCR/YWDYe4/tZEC/sHn89l
jCOVdoY2ZkVHx/yO1Vd0UeoAE94XFsiw0sKwy0lVXLxi3nBIjfh41qZkGoS2lQuo
YSi7PE2o6T5WmluEQfTnUn1DAX0sigUYvWAxnpDYM6I+m8RS0QB7VYSaoqaT3T8D
qomO8FmBN75JrwoywWBDiVRjnxfQJzt6bBK92GUIo6+af6RUSQ9xwQg6EPp3E3r6
FFqIHJ6HaRFCml1KMD4azopVC/bbbhvnbE/EO/5In2nbBsVK06XpBlLWfCyiD48q
NkjnAjISweWTCoMdhULaXdLGeWH85DWoDtvDTCbK+m/QBXRXdiAbij0fDFDhPck=
=QIq6
-----END PGP SIGNATURE-----
