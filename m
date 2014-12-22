Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbaLVCKK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 21:10:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52668 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbaLVCKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 21:10:08 -0500
X-AuditID: cbfee68f-f791c6d000004834-84-54977d7d8fc1
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <54977D7C.9040307@samsung.com>
Date: Mon, 22 Dec 2014 11:10:04 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, anton@enomsg.org,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com
Subject: Re: [PATCH V3 08/11] power: charger-manager: Make chraging decision
 focusing on battery status.
References: <1418979323-7188-1-git-send-email-jonghwa3.lee@samsung.com>
 <1418979323-7188-9-git-send-email-jonghwa3.lee@samsung.com>
 <20141220002440.GC1694@amd>
In-reply-to: <20141220002440.GC1694@amd>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkQLe2dnqIwebdkhYHt2paXP/ynNVi
	0pP3zBYTV05mtri8aw6bxefeI4wWtxtXsFncPXWUzeL07hIHTo8J/Z8YPXbOusvusXmFlsem
	VZ1sHn1bVjF6rFj9nd3j8ya5APYoLpuU1JzMstQifbsEroy+CxwF6zgrjm8MbmDczN7FyMkh
	IWAicWHDDiYIW0ziwr31bF2MXBxCAksZJX4e3sUMU/Tg4GJmiMQiRonjN1azgSR4BQQlfky+
	xwJiMwuoS0yat4gZwhaR+PP6NjuErS2xbOFrqObXjBJL111hhmjWkvg/ZSoriM0ioCqxbUU/
	2BlsAnISb5u+MYLYogJhElcnHAdbICIgL7G1bwXYIGaBPYwSE7a0gG0QFsiSmPNiAVizkMBi
	RolZzw27GDk4OAU0JJ6fhXrtI7vEnx8eELsEJL5NPsQCUiIhICux6QDUk5ISB1fcYJnAKD4L
	yWuzkLw2C8lrs5C8toCRZRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGYBSf/vesfwfj3QPW
	hxgFOBiVeHg506aHCLEmlhVX5h5iNAW6aCKzlGhyPjBV5JXEGxqbGVmYmpgaG5lbmimJ8y6U
	+hksJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgdHf++LqvqtnnYvvHltVUL7hcO/N30tc3kzN
	T/550tRE9026IeOy64LtFXvWHrspYVO3rtry2Tz2T7parhdDjL0TP97arn+Y2c/6579lWflP
	X9XVbDuj1KW0dKVLjJzINTmDCwqi4Y1PLbNX3LXZdTByxhs125XfZJtOuy3l7jCapTnJaIuf
	Ca8SS3FGoqEWc1FxIgBavHv43QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jAd3a2ukhBk3vBS0ObtW0uP7lOavF
	pCfvmS0mrpzMbHF51xw2i8+9RxgtbjeuYLO4e+oom8Xp3SUOnB4T+j8xeuycdZfdY/MKLY9N
	qzrZPPq2rGL0WLH6O7vH501yAexRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW
	5koKeYm5qbZKLj4Bum6ZOUCHKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ
	axgzrtz4xVYwi7Pi/f1vLA2M89m7GDk5JARMJB4cXMwMYYtJXLi3nq2LkYtDSGARo8TxG6vZ
	QBK8AoISPybfY+li5OBgFpCXOHIpGyTMLKAuMWneImaI+teMEkvXXWGGqNeS+D9lKiuIzSKg
	KrFtRT8TiM0mICfxtukbI4gtKhAmcXXCcRYQWwRo5ta+FWCDmAX2MEpM2NICdp2wQJbEnBcL
	wJqFBBYzSsx6bghyBKeAhsTzs0wTGAVmITlvFsJ5s5Cct4CReRWjaGpBckFxUnquoV5xYm5x
	aV66XnJ+7iZGcNQ/k9rBuLLB4hCjAAejEg8vR9r0ECHWxLLiytxDjBIczEoivPf8gUK8KYmV
	ValF+fFFpTmpxYcYTYGem8gsJZqcD0xIeSXxhsYmZkaWRuaGFkbG5krivEr2bSFCAumJJanZ
	qakFqUUwfUwcnFINjNMYZnYbX6qbsFqrjO9dpXL03qjrMttWBD18/LP1TyFnjc2BRru4NdKf
	XTQS7QTc9Bbl29X6n7wy6+6V03s+yj+TycnR3DZvXfqEXZ48cc/dda+W7XgbXyjEdj5/w8S/
	TzKP/+J6sLvm0jqGY+9+iIT2XX7ek6jwX2rbQb87coKhPsHPXioyPVViKc5INNRiLipOBACU
	QDQiEAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014년 12월 20일 09:24, Pavel Machek wrote:

> Subject: charging.
> 


(snip..)


>> --- a/include/linux/power/charger-manager.h
>> +++ b/include/linux/power/charger-manager.h
>> @@ -220,6 +220,7 @@ struct charger_desc {
>>   *	saved status of battery before entering suspend-to-RAM
>>   * @charging_start_time: saved start time of enabling charging
>>   * @charging_end_time: saved end time of disabling charging
>> + * @battery_status: Current battery status
> 
> "current" for consistency.
> 
>>   */
>>  struct charger_manager {
>>  	struct list_head entry;
>> @@ -237,6 +238,8 @@ struct charger_manager {
>>  
>>  	u64 charging_start_time;
>>  	u64 charging_end_time;
>> +
>> +	int battery_status;
>>  };
> 
> Should battery_status be some kind of enum?


Currently, it stores only enum of power_supply class's and it doesn't have
specified type. And also, I didn't want to make additional private enums.
I'd let it to be as it was.

Thanks,
Jonghwa

> 									Pavel
> --						
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 


