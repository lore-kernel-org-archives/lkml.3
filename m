Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab3HZBbI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 21:31:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19218 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab3HZBbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 21:31:06 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-0d-521aafd48c79
Message-id: <521AAFDF.9090608@samsung.com>
Date: Mon, 26 Aug 2013 10:31:11 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>
Cc: Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 2/3] mmc: dw_mmc: Honor requests to set the clock to 0
 (turn off clock)
References: <1377188348-3418-1-git-send-email-dianders@chromium.org>
 <1377188348-3418-3-git-send-email-dianders@chromium.org>
 <521761F1.60203@samsung.com>
 <CAD=FV=WrZacm7UUB3-qE=ufwkur_55m0puPNdUaGBYszPw9OdQ@mail.gmail.com>
In-reply-to: <CAD=FV=WrZacm7UUB3-qE=ufwkur_55m0puPNdUaGBYszPw9OdQ@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsWyRsSkRPfqeqkggwPaFo/XLGayeDBvG5vF
	9tcb2SzOLjvIZvHqyA8mi3fzXjBb3PjVxmpxedccNosj//sZLU5d/8xm8eH+RWaLVbv+MDrw
	eMxuuMjisXPWXXaPnp1nGD0OXVnL6HHlRBOrR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGVM
	2v2RteCEUMXLhi2sDYyv+boYOTkkBEwkvm1oZ4GwxSQu3FvPBmILCSxllJjQywFTM/fSMaA4
	F1B8EaPErW+XoJzXjBJN7UfAOngFtCTaJixkBbFZBFQlTs/+zgxiswnoSGz/dpwJxBYVCJN4
	8WoXM0S9oMSPyffANosIaEo8a3jJDDKUWeAas8TJcxfBBgkLJEjcPX2VFWLbU0aJGZ8vgyU4
	BYIlZl66zwhiMwNt2N86jQ3ClpfYvOYt2CQJgVYOiZnfHrJDnCQg8W3yIaB1HEAJWYlNB5gh
	fpOUOLjiBssERrFZSI6ahWTsLCRjFzAyr2IUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIjN/T
	/57172C8e8D6EGMy0MqJzFKiyfnA+M8riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1
	OzW1ILUovqg0J7X4ECMTB6dUA+OE3Y81jR05/sbMtYmanKzlvMhcV6P/R+Srwldy8X5Muo/T
	9ls7J4r9VAzf9mDCEfW//vNEci5oZqxK/7BrcVFJDschff8tSwqPCApeP27s3BxzRPhD0n+R
	ANYq66Bw7ffl06a8EFSVPtundnt2n5ibYJYV60IZMzbtA68nC2gsk7E8mLKoTImlOCPRUIu5
	qDgRAKfvktr1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jAd0r66WCDJ7fNbF4vGYxk8WDedvY
	LLa/3shmcXbZQTaLV0d+MFm8m/eC2eLGrzZWi8u75rBZHPnfz2hx6vpnNosP9y8yW6za9YfR
	gcdjdsNFFo+ds+6ye/TsPMPocejKWkaPKyeaWD36tqxi9Pi8SS6APaqB0SYjNTEltUghNS85
	PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6FQlhbLEnFKgUEBicbGSvh2m
	CaEhbroWMI0Rur4hQXA9RgZoIGENY8ak3R9ZC04IVbxs2MLawPiar4uRk0NCwERi7qVjbBC2
	mMSFe+uBbC4OIYFFjBK3vl2Ccl4zSjS1HwGr4hXQkmibsJAVxGYRUJU4Pfs7M4jNJqAjsf3b
	cSYQW1QgTOLFq13MEPWCEj8m32MBsUUENCWeNbxkBhnKLHCNWeLkuYtgg4QFEiTunr7KCrHt
	KaPEjM+XwRKcAsESMy/dZwSxmYE27G+dxgZhy0tsXvOWeQKjwCwkS2YhKZuFpGwBI/MqRtHU
	guSC4qT0XEO94sTc4tK8dL3k/NxNjOAE8UxqB+PKBotDjAIcjEo8vIEFUkFCrIllxZW5hxgl
	OJiVRHhdHSSDhHhTEiurUovy44tKc1KLDzEmA8NgIrOUaHI+MHnllcQbGpuYGVkamRtaGBmb
	kyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVANj+K8jO6RPhRxSq/Z9L2nQIGVy8sO1lfPe
	Rukm1MernLrQrVzHlPRlRl2hZcFjK4HVjQ77n8YYXrx7Rf6lRN0J2++17aIKZzp+vd10YNbm
	GcYX1T4wXg4S3dUjJb8q/uKMOY5ibhI3em8yRHVtuxr2q7dypYZi+kWp/XXh/7azOMw9J/U8
	/eF0JZbijERDLeai4kQAiXjEP1QDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On 08/24/2013 05:40 AM, Doug Anderson wrote:
> Jaehoon,
> 
> On Fri, Aug 23, 2013 at 6:21 AM, Jaehoon Chung <jh80.chung@samsung.com> wrote:
>> Hi Doug,
>>
>> If the clock-gating is enabled, then maybe it's continuously printed the kernel message for Bus_speed.
> 
> Can you explain?  I don't think dw_mmc has support for clock gating
> right now.  ...or are there some patches that I'm not aware of?  I
> could believe that if you've got some non-upstream clock gating
> patches that these would need to be modified to handle it...  ...but
> unless those are slated to land upstream it seems like I can't take
> them into account, can I?
If i enabled the CONFIG_MMC_CLK_GATE, the i have found the below message whenever some operation is run.
I will test more with your patch.

[    6.335000] mmc_host mmc1: Bus speed (slot 0) = 100000000Hz (slot req 52000000Hz, actual 50000000HZ div = 1)
[    6.345000] mmc_host mmc1: Bus speed (slot 0) = 100000000Hz (slot req 52000000Hz, actual 50000000HZ div = 1)
[    6.355000] mmc_host mmc1: Bus speed (slot 0) = 100000000Hz (slot req 52000000Hz, actual 50000000HZ div = 1)
[    6.365000] mmc_host mmc1: Bus speed (slot 0) = 100000000Hz (slot req 52000000Hz, actual 50000000HZ div = 1)
[    6.375000] mmc_host mmc1: Bus speed (slot 0) = 100000000Hz (slot req 52000000Hz, actual 50000000HZ div = 1)
[    6.480000] mmc_host mmc1: Bus speed (slot 0) = 100000000Hz (slot req 52000000Hz, actual 50000000HZ div = 1)
[    6.490000] mmc_host mmc1: Bus speed (slot 0) = 100000000Hz (slot req 52000000Hz, actual 50000000HZ div = 1)
[    6.500000] mmc_host mmc1: Bus speed (slot 0) = 100000000Hz (slot req 52000000Hz, actual 50000000HZ div = 1)
[    6.530000] mmc_host mmc1: Bus speed (slot 0) = 100000000Hz (slot req 52000000Hz, actual 50000000HZ div = 1)
[    6.535000] mmc_host mmc1: Bus speed (slot 0) = 100000000Hz (slot req 52000000Hz, actual 50000000HZ div = 1)
[    6.545000] mmc_host mmc1: Bus speed (slot 0) = 100000000Hz (slot req 52000000Hz, actual 50000000HZ div = 1)

Best Regards,
Jaehoon Chung
> 
> Thanks!
> 
> -Doug
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

