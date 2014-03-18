Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbaCRAq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 20:46:58 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:48911 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbaCRAqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 20:46:48 -0400
MIME-Version: 1.0
In-Reply-To: <87d2hkldmx.fsf@nemi.mork.no>
References: <1394952550-9308-1-git-send-email-benchan@chromium.org>
 <1394952550-9308-2-git-send-email-benchan@chromium.org> <87ob15maa6.fsf@nemi.mork.no>
 <CAC5Y2nN_w46FczgitbPjmXtk7q3rHpTxLddx0_GtStfzNXerXQ@mail.gmail.com> <87d2hkldmx.fsf@nemi.mork.no>
From: Ben Chan <benchan@chromium.org>
Date: Mon, 17 Mar 2014 17:46:27 -0700
X-Google-Sender-Auth: v0G2TW2hc0sIHFDaS2fyCdmZbJs
Message-ID: <CAC5Y2nMdPM8w3=dgd2as5z8huL1XLPjon8wSmR-2e3=JGWtCpA@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: cdc_ncm: respect operator preferred MTU reported
 by MBIM
To: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Greg Suarez <gsuarez@smithmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 2:27 PM, Bjørn Mork <bjorn@mork.no> wrote:

>
> This sounds all reasonable to me. Thanks for taking the time to explain
> it in such detail. I did know that some vendors set wMaxSegmentSize too
> low, but had no idea that vendors were using the extended descriptor
> instead of MBIM_CID_IP_CONFIGURATION.
>
> If so, then yes, it does make sense for the driver to base the default
> MTU on this descriptor.

Hopefully, subsequent MBIM specifications would further clarify and
simplify things a bit, but it's gonna be a slow process as we all know
:-/

>
>>> wMTU access needs le16_to_cpu.
>>
>> Good catch. I will fix it in patch v2.
>
> Tip: I found this because my test script/makefile includes
> "C=1 CF=-D__CHECK_ENDIAN__"
>
> I find that very useful when dealing with USB on a little endian system,
> like most of us have.  It's all too easy to miss a conversion otherwise.
>

Thanks again for the review and tip. I've submitted patch v2 to
address the le16_to_cpu conversion.


>>> Could we move this final MTU correction from cdc_ncm_setup to
>>> cdc_ncm_bind_common to avoid bloating the device struct with another
>>> descriptor pointer we donæt really need to keep around?
>>>
>>> I know we look into descriptors in cdc_ncm_setup, because we have to,
>>> but ideally I would have loved to see cdc_ncm_setup dealing with *just*
>>> the NCM/MBIM specific control setup messages and cdc_ncm_bind_common
>>> dealing with all the functional descriptors.  That seems most logic to
>>> me (but is of course only my personal opinion and nothing else - I do
>>> not know what the original cdc_ncm author intended)
>>>
>>
>> I understand the argument against the extra descriptor pointer. But I
>> think it's better to keep the mtu related code together so that one
>> can easily see how MTU is determined when trying to change or refactor
>> the code. I haven't looked into what cdc_ncm_setup was originally
>> intended for. If we'd like to avoid adding an extra pointer in
>> cdc_ncm_ctx, we could have cdc_ncm_bind passing a locally scoped
>> context to cdc_ncm_setup.
>
> No, the extra pointer doesn't matter much. Just keep it as it is.
>
>
> Bjørn
