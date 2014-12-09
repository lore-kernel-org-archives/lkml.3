Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaLIUhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 15:37:54 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59454 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaLIUhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 15:37:52 -0500
Message-ID: <54875D99.6070301@linaro.org>
Date: Tue, 09 Dec 2014 20:37:45 +0000
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, josh@joshtriplett.org, sam@ravnborg.org,
        Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <Ian.Campbell@citrix.com>, kvm@vger.kernel.org,
        x86@kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mtosatti@redhat.com, Pekka Enberg <penberg@kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        David Rientjes <rientjes@google.com>, xen-devel@lists.xenproject.org,
        Borislav Petkov <bp@suse.de>, David Vrabel <david.vrabel@citrix.com>,
        Benjamin Poirier <bpoirier@suse.de>
Subject: Re: [Xen-devel] [PATCH v3 2/2] x86, arm64, platform, xen, kconfig:
 add xen defconfig helper
References: <1418079900-4640-1-git-send-email-mcgrof@do-not-panic.com> <1418079900-4640-3-git-send-email-mcgrof@do-not-panic.com> <5486BBB1.3040405@linaro.org> <CAB=NE6V+kLaZePAzHim0VxGsd8ew6dS7kN=H=awwz1dpHy5VJw@mail.gmail.com>
In-Reply-To: <CAB=NE6V+kLaZePAzHim0VxGsd8ew6dS7kN=H=awwz1dpHy5VJw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/14 20:22, Luis R. Rodriguez wrote:
> On Tue, Dec 9, 2014 at 1:06 AM, Julien Grall <julien.grall@linaro.org> wrote:
>> Hello Luis,
>>
>> On 08/12/2014 23:05, Luis R. Rodriguez wrote:
>>>
>>> diff --git a/kernel/configs/xen.config b/kernel/configs/xen.config
>>> new file mode 100644
>>> index 0000000..0d0eb6d
>>> --- /dev/null
>>> +++ b/kernel/configs/xen.config
>>> +CONFIG_XEN_MCE_LOG=y
>>
>>
>> MCE is x86 specific.
> 
> That's what I thought too but its available for arm64, so should we
> fix that Kconfig to depend on x86?

Are you sure? On the Linus's repo I have:

config XEN_MCE_LOG
        bool "Xen platform mcelog"
        depends on XEN_DOM0 && X86_64 && X86_MCE

Anyway, the MCE interface in the hypervisor is implemented in arch/x86
not in common code.

>>> +CONFIG_XEN_HAVE_PVMMU=y
>>
>>
>> We don't have PVMMU support on ARM. Shouldn't you move this config in
>> architecture specific code?
> 
> If you are sure then yes.

I'm 100% sure. MMU is handled by the hardware on ARM.

Thinking a bit more about this option. CONFIG_XEN_HAVE_PVMMU can't be
selected by the user. It's automatically added per platform (for
instance see arch/x86/xen/Kconfig).

So maybe it should not even appear in the one of the fragment configs?

Regards,

-- 
Julien Grall
