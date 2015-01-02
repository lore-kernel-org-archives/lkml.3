Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbbABQr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 11:47:57 -0500
Received: from service87.mimecast.com ([91.220.42.44]:36500 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbbABQrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 11:47:55 -0500
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v5 18/18] Documentation: ACPI for ARM64
From: Catalin Marinas <catalin.marinas@arm.com>
X-Mailer: iPhone Mail (12B440)
In-Reply-To: <54A664AB.3030101@linaro.org>
Date: Fri, 2 Jan 2015 16:47:51 +0000
Cc: Graeme Gregory <gg@slimlogic.co.uk>,
        "ashwinc@codeaurora.org" <ashwinc@codeaurora.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>, "olof@lixom.net" <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "lv.zheng@intel.com" <lv.zheng@intel.com>,
        "robh@kernel.org" <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "al.stone@linaro.org" <al.stone@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "robert.moore@intel.com" <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "rric@kernel.org" <rric@kernel.org>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "jcm@redhat.com" <jcm@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "bhelgaas@google.com." <linux-arm-kernel@lists.infradead.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        "Kangkang.Shen@huawei.com" <Kangkang.Shen@huawei.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>
Message-Id: <EE1B062D-90AC-491F-90E7-D7EACF1F5B06@arm.com>
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <1413553034-20956-19-git-send-email-hanjun.guo@linaro.org> <CAJ5Y-eZ5cu9_OhG24yAv+CZq7zKg0vU+eVGekyN+9dDzaz1OhQ@mail.gmail.com> <8fc9550c96a468b3e50d51a37db68a33.squirrel@www.codeaurora.org> <54A3B526.9040903@linaro.org> <20150101200424.GB12770@xora-haswell.xora.org.uk> <54A664AB.3030101@linaro.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
X-OriginalArrivalTime: 02 Jan 2015 16:47:50.0162 (UTC) FILETIME=[D829B720:01D026AB]
X-MC-Unique: 115010216475200601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 Jan 2015, at 09:28, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>>> On 2015年01月02日 04:04, Graeme Gregory wrote:
>>>> On Wed, Dec 31, 2014 at 04:34:46PM +0800, Hanjun Guo wrote:
>>>> On 2014年12月31日 04:13, ashwinc@codeaurora.org wrote:
>>>> Hi Hanjun,
>>>> 
>>>> Overall the document looks good to us. Some minor clarifications below.
>>>> 
>>>>> ---------- Forwarded message ----------
>>>>> From: Graeme Gregory <graeme.gregory@linaro.org>
>>>>> 
>>>>> Add documentation for the guidelines of how to use ACPI
>>>>> on ARM64.
>>>>> 
>>>>> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
>>>>> Signed-off-by: Al Stone <al.stone@linaro.org>
>>>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>>>> ---
>>>>> Documentation/arm64/arm-acpi.txt |  323
>>>>> ++++++++++++++++++++++++++++++++++++++
>>>>> 1 file changed, 323 insertions(+)
>>>>> create mode 100644 Documentation/arm64/arm-acpi.txt
>>>> 
>>>> [..]
>>>> 
>>>>> +Relationship with Device Tree
>>>>> +-----------------------------
>>>> 
>>>> [..]
>>>> 
>>>>> +When booting using ACPI tables, the /chosen node in DT will still be
>>>>> parsed
>>>>> +to extract the kernel command line and initrd path.  No other section of
>>>>> the
>>>>> +DT will be used.
>>>> 
>>>> Is this still true?
>>> 
>>> No, we can booting the ACPI system in EFI stub without dtb. Catalin
>>> also pointed out this issue, I will remove this paragraph.
>> 
>> The paragraph is still correct, the /chosen node is always present even
>> if nothing else is.
> 
> Sorry for the confusing, I mean no dtb needed for the command line if
> ACPI tables are available.
> 
> efi will create a empty dtb if no dtb found, and add the cmd line into
> the new created dtb, I'm just wondering, can we remove the limitation
> for passing the cmd line in /chosen node in the future?

My point is that on an ACPI based system, we don't really care how EFI_STUB passes
the command line to the rest of the kernel. Since UEFI doesn't need to know about
such detail and since ACPI is only supported with EFI_STUB, we don't need to mention
the chosen node in this document. 

At some point we may even change the way EFI_STUB passes the command line to the 
kernel but this is still irrelevant to ACPI. 

Catalin

