Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760369Ab3HNUg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:36:27 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:46244 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760178Ab3HNUgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:36:22 -0400
Message-ID: <520BEA3B.2040005@calxeda.com>
Date: Wed, 14 Aug 2013 15:36:11 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        Rob Herring <rob.herring@calxeda.com>,
        "sergei.shtylyov@cogentembedded.com" 
	<sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v4 1/3] devicetree: create a separate binding description
 for sata_highbank
References: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com> <1376504612-17340-1-git-send-email-mark.langsdorf@calxeda.com> <20130814202728.GJ28628@htj.dyndns.org>
In-Reply-To: <20130814202728.GJ28628@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 03:27 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 14, 2013 at 01:23:30PM -0500, Mark Langsdorf wrote:
>>  Documentation/devicetree/bindings/ata/sata_highbank.txt | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Any ideas on how these should be routed?  The above doesn't apply to
> libata or master as the file doesn't exist there yet.

I accidentally introduced a new commit while cleaning up the patch. The
correct patch text should have been as follows. Do you want me to resubmit?

--Mark Langsdorf
Calxeda, Inc.

---
 .../devicetree/bindings/ata/ahci-platform.txt      | 18 +++---------
 .../devicetree/bindings/ata/sata_highbank.txt      | 34
++++++++++++++++++++++
 2 files changed, 38 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ata/sata_highbank.txt

diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt
b/Documentation/devicetree/bindings/ata/ahci-platform.txt
index 3ec0c5c..89de156 100644
--- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
+++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
@@ -4,27 +4,17 @@ SATA nodes are defined to describe on-chip Serial ATA
controllers.
 Each SATA controller should have its own node.

 Required properties:
-- compatible        : compatible list, contains "calxeda,hb-ahci" or
"snps,spear-ahci"
+- compatible        : compatible list, contains "snps,spear-ahci"
 - interrupts        : <interrupt mapping for SATA IRQ>
 - reg               : <registers mapping>

 Optional properties:
-- calxeda,port-phys: phandle-combophy and lane assignment, which maps each
-			SATA port to a combophy and a lane within that
-			combophy
-- calxeda,sgpio-gpio: phandle-gpio bank, bit offset, and default on or off,
-			which indicates that the driver supports SGPIO
-			indicator lights using the indicated GPIOs
-- calxeda,led-order : a u32 array that map port numbers to offsets
within the
-			SGPIO bitstream.
 - dma-coherent      : Present if dma operations are coherent

 Example:
         sata@ffe08000 {
-		compatible = "calxeda,hb-ahci";
-                reg = <0xffe08000 0x1000>;
-                interrupts = <115>;
-		calxeda,port-phys = <&combophy5 0 &combophy0 0 &combophy0 1
-					&combophy0 2 &combophy0 3>;
+		compatible = "snps,spear-ahci";
+		reg = <0xffe08000 0x1000>;
+		interrupts = <115>;

         };
diff --git a/Documentation/devicetree/bindings/ata/sata_highbank.txt
b/Documentation/devicetree/bindings/ata/sata_highbank.txt
new file mode 100644
index 0000000..e7a6f28
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/sata_highbank.txt
@@ -0,0 +1,34 @@
+* Calxeda AHCI SATA Controller
+
+SATA nodes are defined to describe on-chip Serial ATA controllers.
+The Calxeda SATA controller mostly conforms to the AHCI interface
+with some special extensions to add functionality.
+Each SATA controller should have its own node.
+
+Required properties:
+- compatible        : compatible list, contains "calxeda,hb-ahci"
+- interrupts        : <interrupt mapping for SATA IRQ>
+- reg               : <registers mapping>
+
+Optional properties:
+- dma-coherent      : Present if dma operations are coherent
+- calxeda,port-phys : phandle-combophy and lane assignment, which maps each
+			SATA port to a combophy and a lane within that
+			combophy
+- calxeda,sgpio-gpio: phandle-gpio bank, bit offset, and default on or off,
+			which indicates that the driver supports SGPIO
+			indicator lights using the indicated GPIOs
+- calxeda,led-order : a u32 array that map port numbers to offsets
within the
+			SGPIO bitstream.
+
+Example:
+        sata@ffe08000 {
+		compatible = "calxeda,hb-ahci";
+		reg = <0xffe08000 0x1000>;
+		interrupts = <115>;
+		dma-coherent;
+		calxeda,port-phys = <&combophy5 0 &combophy0 0 &combophy0 1
+					&combophy0 2 &combophy0 3>;
+		calxeda,sgpio-gpio =<&gpioh 5 1 &gpioh 6 1 &gpioh 7 1>;
+		calxeda,led-order = <4 0 1 2 3>;
+        };
-- 
1.8.1.2


