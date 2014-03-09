Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaCIB62 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 20:58:28 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:45920 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaCIB6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 20:58:25 -0500
Message-ID: <531BCABD.6030000@converseincode.com>
Date: Sat, 08 Mar 2014 17:58:21 -0800
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sergei Antonov <saproj@gmail.com>, pageexec@freemail.hu
CC: John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>, davem@davemloft.net,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        =?UTF-8?B?SmFuLVNpbW9uIE3DtmxsZXI=?= <dl9pf@gmx.de>,
        =?UTF-8?B?Vmluw61jaQ==?= =?UTF-8?B?dXMgVGludGk=?= 
	<viniciustinti@gmail.com>,
        Mark Charlebois <charlebm@gmail.com>
Subject: Re: [PATCH v2] mac80211: LLVMLinux: Remove VLAIS usage from mac80211
References: <1394177091.4653.1.camel@jlt4.sipsolutions.net>	<1394241960-1764-1-git-send-email-behanw@converseincode.com>	<CABikg9y_j-SDOsMj1C5uogP0HNj6bsB_ySVFtAh_oNgZ0swd=g@mail.gmail.com>	<531B934C.31666.37555A14@pageexec.freemail.hu> <CABikg9x+Z95bHcDc6iu5hBvRNO-ibM8-34_qA+OA_FjB52SPMw@mail.gmail.com>
In-Reply-To: <CABikg9x+Z95bHcDc6iu5hBvRNO-ibM8-34_qA+OA_FjB52SPMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/14 15:00, Sergei Antonov wrote:
> On 8 March 2014 23:01, PaX Team <pageexec@freemail.hu> wrote:
>> On 8 Mar 2014 at 21:29, Sergei Antonov wrote:
>>
>>>> -       memset(&aead_req, 0, sizeof(aead_req));
>>>> +       char aead_req_data[sizeof(struct aead_request) +
>>>> +                               crypto_aead_reqsize(tfm) +
>>>> +                               CRYPTO_MINALIGN] CRYPTO_MINALIGN_ATTR;
>>                                                       ^^^^^^^^^^^^^^^^^^^^
>> wouldn't the underlined attribute ensure the required alignment?
> Yes. Sorry, I overlooked it.
>
> I would remove unneeded CRYPTO_MINALIGN and get the alignment from the
> target structure:
>          char aead_req_data[sizeof(struct aead_request) +
>                             crypto_aead_reqsize(tfm)]
>                  __attribute__((__aligned__(__alignof__(struct aead_request))));
Even better. Will resubmit.

Behan

-- 
Behan Webster
behanw@converseincode.com

