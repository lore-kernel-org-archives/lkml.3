Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab3GKIQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 04:16:50 -0400
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:2156 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab3GKIQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 04:16:46 -0400
X-IronPort-AV: E=Sophos;i="4.87,1042,1363158000"; 
   d="scan'208";a="47189436"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        <ath10k@lists.infradead.org>
Subject: Re: ath10k: mac80211 driver for Qualcomm Atheros 802.11ac CQA98xx devices
References: <20130710022602.1F6F16609DE@gitolite.kernel.org>
	<alpine.DEB.2.02.1307101859360.29717@ayla.of.borg>
Date: Thu, 11 Jul 2013 11:16:34 +0300
In-Reply-To: <alpine.DEB.2.02.1307101859360.29717@ayla.of.borg> (Geert
	Uytterhoeven's message of "Wed, 10 Jul 2013 19:12:28 +0200")
Message-ID: <87sizl7bq5.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> On Wed, 10 Jul 2013, Linux Kernel Mailing List wrote:
>> --- /dev/null
>> +++ b/drivers/net/wireless/ath/ath10k/hw.h
>
>> +#define SUPPORTED_FW_MAJOR	1
>> +#define SUPPORTED_FW_MINOR	0
>> +#define SUPPORTED_FW_RELEASE	0
>> +#define SUPPORTED_FW_BUILD	629
>
>> +static int ath10k_check_fw_version(struct ath10k *ar)
>> +{
>> +	char version[32];
>> +
>> +	if (ar->fw_version_major >= SUPPORTED_FW_MAJOR &&
>> +	    ar->fw_version_minor >= SUPPORTED_FW_MINOR &&
>> +	    ar->fw_version_release >= SUPPORTED_FW_RELEASE &&
>> +	    ar->fw_version_build >= SUPPORTED_FW_BUILD)
>> +		return 0;
>
> My attention got triggered by:
>
> drivers/net/wireless/ath/ath10k/core.c: In function ‘ath10k_check_fw_version’:
> drivers/net/wireless/ath/ath10k/core.c:79: warning: comparison is always true due to limited range of data type

I haven't seen this warning, I guess my compiler is too old.

> as an u16 is always larger or equal than zero. Not much you can do to
> silence that warning, though.

Too bad, I really would like to keep ath10k warning free. Easier to
maintain that way.

Does anyone have any nice trick in their sleeves to make this warning go
away? I guess one ugly option is to change u16 to int.

>
> However, I don't think the version check is correct.
> Shouldn't it stop checking later fields if an exact match is found in an
> earlier field?
>
> I.e.
>
> 	if (ar->fw_version_major > SUPPORTED_FW_MAJOR ||
> 	    (ar->fw_version_major == SUPPORTED_FW_MAJOR &&
> 	     ar->fw_version_minor > SUPPORTED_FW_MINOR) ||
> 	     ...) { ... }
>
> Currently e.g. (major, minor) = (3, 0) is considered older than (2, 1).

Doh, that is indeed wrong. I'll fix that, thanks for spotting this.

> Or perhaps minor is never reset to zero when major is increased? In that
> case, the check is correct, but IMHO it's a bit silly to split the version
> number in seperate fields.

No, the firmware engineers are supposed to reset minor version whenever
major changes.

-- 
Kalle Valo
