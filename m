Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab3EVIRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:17:50 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:53429 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab3EVIRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:17:46 -0400
MIME-Version: 1.0
In-Reply-To: <519B8021.6030002@gmail.com>
References: <519B8021.6030002@gmail.com>
Date: Wed, 22 May 2013 11:17:45 +0300
Message-ID: <CANUX_P1sMR6ugSt1Q=hA4dLXQ=mo+dqbAoMi4dn46jYhZZzL7A@mail.gmail.com>
Subject: Re: [v3.9.x stable regression, bisected] iwlwifi/iwldvm has a 30s
 delay in EAP authentication
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: kkhere.geo+suse@gmail.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>, gregkh@kroah.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 5:09 PM, Kshitij Kulshreshtha
<kkhere.geo@gmail.com> wrote:
> Hello,
>
> I am currently running the openSUSE Tumbleweed distribution and have a
> problem starting with the kernel v3.9.1 and also with kernel v3.9.2.
>
> The iwldvm driver has an artificial delay of 30s when authenticating
> with a radius server using EAP-TLS. This was not the case using kernel
> v3.9.
>
> I bisected the problem using local builds of the tumbleweed desktop
> configuration. This is the result:
>
> c30f37f8f1f8d06c142d67ba74955fd48b5cf5a4 is the first bad commit
> commit c30f37f8f1f8d06c142d67ba74955fd48b5cf5a4
> Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Date:   Wed Apr 17 09:47:00 2013 +0300
>
>     iwlwifi: dvm: don't send zeroed LQ cmd
>
>     commit 63b77bf489881747c5118476918cc8c29378ee63 upstream.
>
>     When the stations are being restored because of unassoc
>     RXON, the LQ cmd may not have been initialized because it
>     is initialized only after association.
>     Sending zeroed LQ_CMD makes the fw unhappy: it raises
>     SYSASSERT_2078.
>
>     Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>     Reviewed-by: Johannes Berg <johannes.berg@intel.com>
>     [move zero_lq and make static const]
>     Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>

Thanks for the bisection.
Can you please try the patch in
https://bugzilla.kernel.org/show_bug.cgi?id=58341 and report?
Thanks
