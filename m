Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab3GIKmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 06:42:15 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:50717 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611Ab3GIKmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 06:42:14 -0400
Message-ID: <51DBE718.2080007@st.com>
Date: Tue, 09 Jul 2013 11:34:00 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@arm.linux.org.uk>, kernel@stlinux.com,
        linux-kernel@vger.kernel.org, Stuart Menefy <stuart.menefy@st.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1 0/4] ARM: STi fixes and ethernet support
References: <1373271301-11060-1-git-send-email-srinivas.kandagatla@st.com> <201307090118.06715.arnd@arndb.de> <51DBB629.1050000@st.com> <201307090956.03191.arnd@arndb.de>
In-Reply-To: <201307090956.03191.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/13 08:56, Arnd Bergmann wrote:
> No, you should be using generic interfaces to do the things you need.
> 
> I believe what you are missing is an ethernet phy driver that is specific
> to your SoC.
It looks interesting way to solve the issue.

Did you mean "Ethernet PHY"?

Ethernet PHY is not integrated in the STiH41x SoC, We use an external
ICPLUS phy ( drivers/net/phy/icplus.c) for both B2000 and B2020 boards.
As we can't have  two Ethernet phy drivers at the same time, I think the
suggestion might not work in this case.

The callbacks in the mach level are setting up two SOC specific System
Configuration registers which configures the MAC (like PHY interface
selection, which is sampled during MAC reset assertion).

MAC used in STiH41x supports multiple PHY interfaces, so the PHY
interface selection is driven by external signals wired up to System
Configuration registers. The MAC driver is not aware of these System
Configuration registers. So for non-DT case, stmmac driver provided
callbacks to do things like this.

For DT case, At the moment I think callbacks at MACH level is one
possible solution. But am open for any discussions.


Thanks,
srini


> 
> 	Arnd

