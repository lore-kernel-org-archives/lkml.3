Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbbAVQSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:18:55 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:55466 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbbAVQSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:18:54 -0500
MIME-Version: 1.0
In-Reply-To: <20150122161446.101EBC40A80@trevor.secretlab.ca>
References: <1421250356-16690-1-git-send-email-geert+renesas@glider.be> <20150122161446.101EBC40A80@trevor.secretlab.ca>
From: Grant Likely <grant.likely@linaro.org>
Date: Thu, 22 Jan 2015 16:18:32 +0000
X-Google-Sender-Auth: IyCSIz3u2wEPQm_DsvW_Mq2TGrg
Message-ID: <CACxGe6sDFQQfiN0+d5HV7JPE-0bosqdaKqrS-7o-obCy1NP_qg@mail.gmail.com>
Subject: Re: [PATCH] of: Add missing of_node_put() in of_find_node_by_path()
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>
Cc: Gaurav Minocha <gaurav.minocha.os@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 4:14 PM, Grant Likely <grant.likely@linaro.org> wrote:
> On Wed, 14 Jan 2015 16:45:56 +0100
> , Geert Uytterhoeven <geert+renesas@glider.be>
>  wrote:
>> When traversing all nodes and moving to a new path component, the old
>> one must be released by calling of_node_put(). Else the refcounts of the
>> parent node(s) will not be decremented.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> ---
[...]
>> Feel free to (ab)use the code below and derive a unittest from it...

BTW, can you do this please? They are pretty important for core
changes now, and I'm stuck with doing them if the person supplying a
patch does not (and I'm already too much of a bottleneck on the DT
code).

g.
